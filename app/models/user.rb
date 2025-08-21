class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enums
  enum :role, { client: 0, developer: 1, admin: 2 }

  # Associations
  has_many :client_projects, class_name: 'Project', foreign_key: 'client_id'
  has_many :developer_projects, class_name: 'Project', foreign_key: 'developer_id'
  has_many :milestones, through: :client_projects
  has_many :reviews, class_name: 'Review', foreign_key: 'reviewer_id'
  has_many :received_reviews, class_name: 'Review', foreign_key: 'reviewed_id'

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  # Methods
  def client?
    role == 'client'
  end

  def developer?
    role == 'developer'
  end

  def admin?
    role == 'admin'
  end

  def average_rating
    avg = received_reviews.average(:rating)
    avg ? avg.round(1) : 0
  end

  def total_reviews
    received_reviews.count
  end
end
