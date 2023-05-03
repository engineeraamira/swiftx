class Message
    def self.not_found(record = 'record')
      "Sorry, #{record} not found."
    end
  
    def self.invalid_credentials
      'Invalid credentials'
    end
  
    def self.invalid_token
      'Invalid token'
    end
  
    def self.missing_token
      'Missing token'
    end
  
    def self.unauthorized
      'Unauthorized request'
    end
  
    def self.account_created
      'Account created successfully'
    end
  
    def self.account_not_created
      'Account could not be created'
    end
  
    def self.expired_token
      'Sorry, your token has expired. Please login to continue.'
    end

    def self.locked_account
        'your account is locked'
    end

    def self.disabled_account
        'your account is disabled by admin'
    end

    def self.uncofirmed_email
        'you should confirm your email before sign in'
    end
  end