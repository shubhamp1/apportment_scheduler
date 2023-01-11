class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  #callbacks
  after_create :assign_default_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum gender: %i[Male Female Other]


  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, :gender, presence: true


  # adding default role to user
  def assign_default_role
    self.add_role(:patient) unless self.roles.present?
  end
end
