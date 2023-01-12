class HomeController < ApplicationController
  def index
    @doctors = Doctor.all
  end
end
