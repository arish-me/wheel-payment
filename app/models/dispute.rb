class Dispute < ApplicationRecord
  # Associations
  belongs_to :milestone
  belongs_to :raised_by, class_name: 'User'

  # Enums
  enum :status, { open: 0, resolved: 1, closed: 2 }

  # Validations
  validates :reason, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :status, presence: true
  validates :raised_by_id, presence: true

  # Scopes
  scope :open, -> { where(status: 'open') }
  scope :resolved, -> { where(status: 'resolved') }

  # Methods
  def project
    milestone.project
  end

  def client
    milestone.client
  end

  def developer
    milestone.developer
  end

  def can_be_resolved_by?(user)
    user.admin? || user == raised_by
  end

  def resolved_by_admin?
    resolved? && !raised_by.admin?
  end
end
