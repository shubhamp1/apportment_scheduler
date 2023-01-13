class HomeController < ApplicationController
  def index
    if current_user.has_role? :doctor
      @availability = current_user.doctor.availability
      @doctor_view = true
    else
      @doctors = Doctor.all
    end
  end
end
