class Document < ApplicationRecord
  # Associations
  has_many :versions, class_name: "DocumentVersion", dependent: :destroy
  has_many :document_paths, dependent: :destroy
  has_many :document_tags, dependent: :destroy
  has_many :tags, through: :document_tags

  belongs_to :parent_document, class_name: "Document", optional: true
  has_many :variant_documents, class_name: "Document", foreign_key: "parent_document_id"

  # Scopes
  scope :by_type, ->(type) { where(document_type: type) }
  scope :processed, -> { where(ai_processing_status: "completed") }
  scope :pending_processing, -> { where(ai_processing_status: %w[pending processing]) }

  # Validations
  validates :title, presence: true
  validates :variant_type, presence: true, if: -> { parent_document_id.present? }
  validates :ai_processing_status,
            inclusion: { in: %w[pending processing completed failed], message: "is not a valid status" }

  # Instance methods
  def latest_version
    versions.order(version_number: :desc).first
  end

  def all_paths
    document_paths.pluck(:path)
  end

  def variants
    if parent_document
      Document.where(parent_document_id: parent_document_id)
    else
      variant_documents
    end
  end

  def in_path?(path_string)
    document_paths.exists?(path: path_string)
  end

  def add_path(path_string)
    # Adding a path that already exists will raise unique constraint error
    # This method assumes the caller handles the case where path might be taken
    document_paths.create!(path: path_string)
  rescue ActiveRecord::RecordNotUnique
    false
  end

  def remove_path(path_string)
    document_paths.where(path: path_string).destroy_all
  end

  def copy_to_path(new_path)
    # Copy document to a new path (hard link)
    # First check if path is available
    return false if DocumentPath.exists?(path: new_path)

    add_path(new_path)
  end
end
