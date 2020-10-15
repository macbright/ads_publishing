class Api::V1::UsersController < Devise::RegistrationsController

  skip_before_action :verify_authenticity_token, :only => :create
  before_action :authenticate_user!,  only: [:index, :current, :update]
    # before_action :authorize_as_admin, only: [:destroy]
    # before_action :authorize,          only: [:update]
  

  # sign up
  def create
    @user = User.new user_params
    if @user.save
      render json: {
        messages: "Sign Up Successfully",
        is_success: true,
        data: {user: @user}
      }, status: :ok
    else
      render json: {
        messages: "User already exist",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  def current
    current_user.update!(last_login: Time.now)
    render json: current_user
  end

  def update
    @user = User.find_by(email: params[:email])
    if @user.update(user_params)
      render json: {
        messages: "Info Successfully Updated",
        is_success: true,
        data: {user: @user}
      }, status: :ok
    else
      render json: {
        messages: "Updating Failded",
        is_success: false,
        data: {error: @user.error.messages}
      }, status: :unprocessable_entity
    end
  end

  def show 
    @user = User.find_by(id: params[:id])
    render json: @user
  end
   def index 
    @users = User.all
    render json: @users
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { status: 200, msg: 'User has been deleted.' }
    end
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

 

  def authorize
    return_unauthorized unless current_user && current_user.can_modify_user?(params[:id])
  end

  def load_user
    @user = User.find_by(email: sign_in_params[:email])
    if @user
      return @user
    else
      render json: {
        messages: "Cannot get User",
        is_success: false,
        data: {}
      }, status: 402
    end
  end
end