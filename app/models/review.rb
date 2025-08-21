class Review < ApplicationRecord
  # Associations
  belongs_to :milestone
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewed, class_name: 'User'

  # Validations
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 500 }
  validates :reviewer_id, presence: true
  validates :reviewed_id, presence: true
  validate :milestone_must_be_released
  validate :reviewer_must_be_client

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def project
    milestone.project
  end

  private

  def milestone_must_be_released
    unless milestone.released?
      errors.add(:base, 'Can only review released milestones')
    end
  end

  def reviewer_must_be_client
    unless reviewer == milestone.client
      errors.add(:base, 'Only the client can review the milestone')
    end
  end
end
