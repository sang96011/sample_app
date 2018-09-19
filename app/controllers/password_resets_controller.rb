class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.email_sent"
      redirect_to root_path
    else
      flash.now[:danger] = t "flash.email_nfound"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("flash.cant_empty"))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t "flash.pass_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "flash.err_find"
    redirect_to root_path
  end

  def valid_user
    redirect_to root_path unless (@user && @user.activated? &&
      @user.authenticated?(:reset, params[:id]))
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "flash.pass_expired"
    redirect_to new_password_reset_url
  end
end
