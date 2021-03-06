class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.find_by_activated.order_desc.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    redirect_to root_url && return unless @user.activated
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.acc_check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    return render :edit unless @user.update_attributes user_params
    flash[:success] = t "flash.update_success"
    redirect_to @user
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.destroy"
    else
      flash[:danger] = t "flash.err_find"
    end
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def correct_user
    return if current_user?(@user)
    flash[:danger] = t "flash.not_you"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "flash.err_find"
    redirect_to root_path
  end
end
