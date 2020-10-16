class Api::V1::SessionsController < Devise::SessionsController
  
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :authenticate_user!, only: :destroy
  # sign in
  def create
    # warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # render json: {
    #   is_success: true,
    #   messages: "Signed In Successfully",
    #   date: {user: resource}
    #   }

    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      curr_user = @user
      render json: {
        messages: "Signed In Successfully",
        is_success: true,
        data: {user: @user}
      }, status: :ok
    else
      render json: {
        messages: "Signed In Failed - Unauthorized",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    head :no_content
    
  end


  private
  def sign_in_params
    params.permit(:email, :password)
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