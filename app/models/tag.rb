class Tag < ApplicationRecord
  # Associations
  has_many :document_tags, dependent: :destroy
  has_many :documents, through: :document_tags

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :tag_type, presence: true, inclusion: { in: %w[simple key_value folder] }
  validates :key, presence: true, if: -> { tag_type == "key_value" }
  validates :value, presence: true, if: -> { tag_type == "key_value" }

  # Scopes
  scope :simple, -> { where(tag_type: "simple") }
  scope :key_value, -> { where(tag_type: "key_value") }
  scope :folder, -> { where(tag_type: "folder") }
  scope :with_key, ->(key) { where(key: key) }
  scope :popular, -> { order(usage_count: :desc) }

  # Class methods
  def self.find_or_create_simple(name)
    find_or_create_by!(name: name, tag_type: "simple")
  end

  def self.find_or_create_key_value(key, value)
    find_or_create_by!(tag_type: "key_value", key: key, value: value) do |tag|
      tag.name = "#{key}:#{value}"
    end
  end

  def self.find_or_create_folder(name)
    find_or_create_by!(name: name, tag_type: "folder")
  end

  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end

  # Instance methods
  def increment_usage!
    increment!(:usage_count)
  end

  def decrement_usage!
    decrement!(:usage_count) if usage_count > 0
  end

  def simple?
    tag_type == "simple"
  end

  def key_value?
    tag_type == "key_value"
  end

  def folder?
    tag_type == "folder"
  end
end
