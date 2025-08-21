class Transaction < ApplicationRecord
  # Associations
  belongs_to :milestone

  # Enums
  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3, refunded: 4 }
  enum :payment_provider, { stripe: 0, razorpay: 1 }

  # Validations
  validates :payment_provider, presence: true
  validates :provider_id, presence: true, uniqueness: true
  validates :status, presence: true
  validates :fee_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :net_amount_cents, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :completed, -> { where(status: 'completed') }
  scope :failed, -> { where(status: 'failed') }
  scope :refunded, -> { where(status: 'refunded') }

  # Money handling
  monetize :fee_cents
  monetize :net_amount_cents

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

  def total_amount
    fee + net_amount
  end
end
