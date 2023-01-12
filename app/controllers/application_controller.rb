# This is the base controller for all other controllers in the application.
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # This is a Devise method that will ensure that the user is logged in
  # before any action is performed on this controller.
  before_action :authenticate_user!
end
