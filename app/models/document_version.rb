class DocumentVersion < ApplicationRecord
  # Associations
  belongs_to :document
  belongs_to :upload_batch, optional: true
  has_one_attached :file

  # Validations
  validates :version_number, presence: true, uniqueness: { scope: :document_id }
  validates :version_name, uniqueness: { scope: :document_id, allow_nil: true }

  # Callbacks
  before_validation :assign_version_number, on: :create
  after_create :update_document_timestamp

  # Scopes
  scope :by_version_number, ->(num) { where(version_number: num) }
  scope :in_batch, ->(batch_id) { where(upload_batch_id: batch_id) }

  # Instance methods
  def file_url
    Rails.application.routes.url_helpers.rails_blob_url(file) if file.attached?
  end

  def file_size
    file_metadata["size"] || 0
  end

  def mime_type
    file_metadata["mime_type"]
  end

  private

  def assign_version_number
    return if version_number.present?

    max_version = document.versions.maximum(:version_number) || 0
    self.version_number = max_version + 1
  end

  def update_document_timestamp
    document.touch
  end
end
