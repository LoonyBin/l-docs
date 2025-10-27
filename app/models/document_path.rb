class DocumentPath < ApplicationRecord
  # Associations
  belongs_to :document

  # Validations
  validates :path, presence: true, uniqueness: true

  # Scopes
  scope :for_path, ->(path) { where(path: path) }

  # Class methods
  def self.for_document_in_path(path_string)
    joins(:document).where(path: path_string)
  end

  def self.folder_tree
    all.pluck(:path).uniq.sort
  end

  def self.documents_in_folder(folder_path)
    where("path LIKE ?", "#{folder_path}%")
  end
end
