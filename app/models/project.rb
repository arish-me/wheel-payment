class Project < ApplicationRecord
  # Associations
  belongs_to :client, class_name: 'User'
  belongs_to :developer, class_name: 'User'
  has_many :milestones, dependent: :destroy
  has_many :disputes, through: :milestones

  # Enums
  enum :status, { draft: 0, active: 1, completed: 2, cancelled: 3 }

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :status, presence: true
  validates :client_id, presence: true
  validates :developer_id, presence: true

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }

  # Methods
  def total_milestone_amount
    milestones.sum(:amount_cents)
  end

  def funded_milestone_amount
    milestones.funded.sum(:amount_cents)
  end

  def completed_milestone_amount
    milestones.completed.sum(:amount_cents)
  end

  def released_milestone_amount
    milestones.released.sum(:amount_cents)
  end
end
