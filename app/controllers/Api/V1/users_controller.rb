class Api::V1::UsersController < Devise::RegistrationsController
  before_action :ensure_params_exist, only: :create
  skip_before_action :verify_authenticity_token, :only => :create
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
        messages: "Sign Up Failded",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])
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

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def ensure_params_exist
    return if params[:user].present?
    render json: {
        messages: "Missing Params",
        is_success: false,
        data: {}
      }, status: :bad_request
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