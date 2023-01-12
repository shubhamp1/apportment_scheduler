class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_one :doctor, dependent: :destroy
  has_many :appointments, foreign_key: 'patient_id'

  # callbacks
  after_create :assign_default_role
  after_create :connect_doctor

  # enum
  enum gender: %i[Male Female Other]

  # scopes
  scope :doctor, -> { with_role :doctor }

  # validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, :gender, presence: true

  # adding default role to user
  def assign_default_role
    self.add_role(:patient) unless self.roles.present?
  end

  def connect_doctor
    Doctor.create(user_id: self.id, name: self.full_name) if self.has_role? :doctor
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_doctor?
    self.has_role? :doctor
  end

end
