class Api::V1::TypesController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :authorize, except: [:show, :index]

  # sign up
  def create
    @type = current_user.types.new type_params
    if @type.save
      render json: {
        messages: "Type Successfully",
        is_success: true,
        data: {user: @type}
      }, status: :ok
    else
      render json: {
        messages: @type.errors,
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  

  def update
    @type = Type.find_by(id: params[:id])
    @type.user_id = current_user.id
    if @type.update(type_params)
      render json: {
        messages: "Info Successfully Updated",
        is_success: true,
        data: {user: @type}
      }, status: :ok
    else
      render json: {
        messages: "Updating Failded",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  def show 
    @type = Type.find_by(id: params[:id])
    render json: @type
  end
   def index 
    @types = Type.all
    render json: @types
  end

  def destroy
    @type = Type.find_by(id: params[:id])
    if @type.destroy
      head :no_content
    else 
      render json: {error: "problem deleting user" }, status: 422
    end
  end


  private
  def type_params
    params.permit(:title)
  end

  def authorize
    render json: {error: " unauthorized access, action can only be perform by admin" } unless current_user.is_admin?
  end
end
