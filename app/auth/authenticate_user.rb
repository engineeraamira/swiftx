class AuthenticateUser
    include Clearance::Authentication
    def initialize(email, password)
      @email = email
      @password = password
    end
  
    # Service entry point
    def call
        payload(user) if user
      #JsonWebToken.encode(user_id: user.id) if user
    end
  
    private
  
    attr_reader :email, :password
  
    # verify user credentials
    def user
      user = User.find_by(email: @email)
      if user 
        @token = Random.new.rand(111111..999999)
        @account_status = Verification.where(user_id: user.id).first
        if user.status == false
            raise(ExceptionHandler::AuthenticationError, Message.disabled_account)
        elsif !(user.authenticate(@email,@password))
            raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
        elsif user.authenticate(@email,@password)
            return user 
        end
      else
        # raise Authentication error if credentials are invalid
        raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
      end
    end

    def payload(user)
        return nil unless user and user.id
        {
            auth_token: JsonWebToken.encode({user_id: user.id},""),
            user: {id: user.id, email: user.email}
            }
    end

    def payload2(user)
        return nil unless user and user.id
        {
            Temporary_token: JsonWebToken.encode({user_id: user.id},15.minutes.from_now),
            user: {id: user.id, email: user.email}
            }
    end
end
  