class Developer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable, :confirmable, :trackable

  # Associations
  has_many :apps, dependent: :nullify

  # Rails 8 enum syntax
  enum :status, { pending: 0, active: 1, suspended: 2 }, default: :pending
  enum :role, { developer: 0 }, default: :developer

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :github, uniqueness: true, allow_nil: true

  # Helper methods
  def active?
    status == 'active'
  end

  def suspended?
    status == 'suspended'
  end

  def pending?
    status == 'pending'
  end
end
