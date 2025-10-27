class UploadBatch < ApplicationRecord
  # Associations
  has_many :document_versions, dependent: :nullify

  # Validations
  validates :status, presence: true, inclusion: {
    in: %w[uploading processing completed failed],
    message: "is not a valid status"
  }

  # Callbacks
  before_create :set_default_values

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :incomplete, -> { where(status: %w[uploading processing]) }

  # Instance methods
  def progress_percentage
    return 0 if total_files.zero?

    (processed_files.to_f / total_files * 100).round
  end

  def increment_processed!
    increment!(:processed_files)
    check_completion
  end

  def documents
    documents = []
    document_versions.includes(:document).each do |version|
      documents << version.document unless documents.include?(version.document)
    end
    documents
  end

  private

  def set_default_values
    self.status ||= "uploading"
    self.total_files ||= 0
    self.processed_files ||= 0
    self.ai_context ||= {}
  end

  def check_completion
    if processed_files >= total_files && status != "completed"
      update(status: "completed")
    end
  end
end
