class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == Settings.login.remember ?
          remember(@user) : forget(@user)
        redirect_back_or @user
      else
        flash[:warning] = t "flash.acc_not_active"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "flash.err_signin"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:danger] = t "flash.err_find"
    redirect_to root_path
  end
end
