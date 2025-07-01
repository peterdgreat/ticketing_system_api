class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_signed_out_user
  def create
    user = User.find_by_email(params[:user][:email]&.downcase)
    if user&.valid_password?(params[:user][:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { token: token, user: { id: user.id, email: user.email, role: user.role } }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    user = current_user
    user.update(jti: nil) if user
    sign_out
    render json: { message: "Logged out succesfully" }, status: :ok
  end
end
