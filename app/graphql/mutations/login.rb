module Mutations
  class Login < GraphQL::Schema::Mutation
    argument :email, String, required: true
    argument :password, String, required: true
    type Types::AuthPayloadType
    def resolve(email:, password:)
      user = User.find_by(email: email.downcase)
      #Not sure how authebticate was working and stopped working now!(spent hrs here)
      # unless user&.authenticate(password)
      #   raise GraphQL::ExecutionError, 'Invalid email or password'
      # end
      unless user && BCrypt::Password.new(user.encrypted_password) == password
        raise GraphQL::ExecutionError, 'Invalid email or password'
      end
      user.update(jti: SecureRandom.uuid)
      token = JWT.encode({ jti: user.jti, sub: user.id, exp: 1.day.from_now.to_i }, Rails.application.credentials.secret_key_base, 'HS256')
      Rails.logger.debug "Generated JWT token: #{token}"
      { user: user, token: token }
    end
  end
end
