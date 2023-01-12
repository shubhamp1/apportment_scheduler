class Doctor < ApplicationRecord
  belongs_to :user
  has_many :appointments, dependent: :destroy
  has_one :availability, dependent: :destroy



   # methods
   def self.disabled_days(availability)
    disabled_days = []
    (0..6).each do |value|
      unless value.between?(Availability.start_days[availability.start_day], Availability.end_days[availability.end_day])
        disabled_days << value
      end
    end
  end
end
