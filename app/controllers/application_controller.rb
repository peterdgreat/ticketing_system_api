class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_user_from_token

  private

  def authenticate_user_from_token
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        @current_user = User.find(payload['sub'])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        head :unauthorized
      end
    end
  end

  def current_user
    @current_user
  end

  def pundit_user
    current_user
  end
end
