module Mutations
  class SignUp < GraphQL::Schema::Mutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :role, String, required: true
    type Types::AuthPayloadType

    def resolve(email:, password:, role:)
      user = User.new(email: email.downcase, password: password, role: role, jti: SecureRandom.uuid)
      if user.save
        token = JWT.encode({ jti: user.jti, sub: user.id, exp: 1.day.from_now.to_i }, Rails.application.credentials.secret_key_base, 'HS256')
        Rails.logger.debug "Generated JWT token: #{token}"
        { user: user, token: token }
      else
        raise GraphQL::ExecutionError, user.errors.full_messages.join(', ')
      end
    end
  end
end
