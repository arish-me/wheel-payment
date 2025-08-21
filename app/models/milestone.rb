class Milestone < ApplicationRecord
  # Associations
  belongs_to :project
  has_many :transactions, dependent: :destroy
  has_many :disputes, dependent: :destroy
  has_one :review, dependent: :destroy

  # Enums
  enum :status, { pending: 0, funded: 1, completed: 2, released: 3, refunded: 4 }

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true, inclusion: { in: %w[USD EUR GBP INR] }
  validates :status, presence: true

  # Scopes
  scope :funded, -> { where(status: 'funded') }
  scope :completed, -> { where(status: 'completed') }
  scope :released, -> { where(status: 'released') }

  # Money handling
  monetize :amount_cents

  # Methods
  def client
    project.client
  end

  def developer
    project.developer
  end

  def can_be_funded?
    pending?
  end

  def can_be_completed?
    funded?
  end

  def can_be_released?
    completed?
  end

  def can_be_refunded?
    funded? || completed?
  end

  def platform_fee
    (amount_cents * ENV.fetch('PLATFORM_FEE_PERCENT', 5).to_f / 100).round
  end

  def developer_amount
    amount_cents - platform_fee
  end
end
