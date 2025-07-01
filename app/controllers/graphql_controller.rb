class GraphqlController < ApplicationController
  include Devise::Controllers::Helpers

  def execute
    query = params[:query]
    variables = ensure_hash(params[:variables])
    current_user = is_public_mutation? ? nil : authenticate_user_from_jwt
    Rails.logger.debug "Devise JWT Auth: User=#{current_user&.id}, Token=#{request.headers['Authorization']}"
    context = {
      current_user: current_user
    }

    result = TicketingSystemSchema.execute(query, variables: variables, context: context)
    render json: result
  rescue => e
    Rails.logger.error "GraphQL Error: #{e.message}, Backtrace: #{e.backtrace.join("\n")}"
    render json: { errors: [{ message: e.message }] }, status: :internal_server_error
  end

  private

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      ambiguous_param.present? ? JSON.parse(ambiguous_param) : {}
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def is_public_mutation?
    query = params[:query]
    return false unless query

    query.match?(/mutation\s*(?:SignUp|login)\s*(?:\([^)]*\))?\s*{\s*(signUp|login)\s*\(/i) ||
      params[:operationName]&.match?(/^(SignUp|login)$/i)
  end

  def authenticate_user_from_jwt
    token = request.headers['Authorization']&.split('Bearer ')&.last
    return nil unless token

    begin
      payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
      user = User.find_by(jti: payload['jti'])
      if user
        Rails.logger.debug "JWT Auth Success: User ID=#{user.id}, JTI=#{payload['jti']}"
        return user
      else
        Rails.logger.warn "Invalid JWT: User not found for jti #{payload['jti']}"
        render json: { errors: [{ message: 'Unauthorized' }] }, status: :unauthorized
        return nil
      end
    rescue JWT::DecodeError => e
      Rails.logger.warn "JWT Decode Error: #{e.message}"
      render json: { errors: [{ message: 'Invalid token' }] }, status: :unauthorized
      nil
    rescue JWT::ExpiredSignature
      Rails.logger.warn "JWT Expired: #{token}"
      render json: { errors: [{ message: 'Token expired' }] }, status: :unauthorized
      nil
    end
  end
end
