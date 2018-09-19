class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
    render html: "hello, world!"
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "flash.login_please"
    redirect_to login_path
  end
end
