class JsonWebToken

    # secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  
  # encode user data using secret key to generate json web token
  def self.encode(payload, exp)
 # def self.encode(payload)
       # set expiry to 24 hours from creation time
       if (exp != "")
          payload[:exp] = exp.to_i
       end
       # sign token with application secret
       JWT.encode(payload, HMAC_SECRET)
  end

  # decode json web token and return with user 
  def self.decode(token)
      # get payload; first index in decoded Array
      body = JWT.decode(token, HMAC_SECRET)[0]
      return HashWithIndifferentAccess.new body
      rescue JWT::DecodeError => e
           # raise custom error to be handled by custom handler
         raise ExceptionHandler::InvalidToken, e.message
  end
end

