class DocumentTag < ApplicationRecord
  # Associations
  belongs_to :document
  belongs_to :tag

  # Validations
  validates :document_id, uniqueness: { scope: :tag_id }

  # Callbacks
  after_create :increment_tag_usage
  after_destroy :decrement_tag_usage

  # Scopes
  scope :ai_generated, -> { where(ai_generated: true) }
  scope :user_added, -> { where(ai_generated: false) }
  scope :high_confidence, -> { where("confidence > ?", 0.8) }
  scope :low_confidence, -> { where("confidence < ?", 0.5) }

  private

  def increment_tag_usage
    tag.increment_usage!
  end

  def decrement_tag_usage
    tag.decrement_usage!
  end
end
