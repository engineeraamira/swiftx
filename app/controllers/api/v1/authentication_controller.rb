
class Api::V1::AuthenticationController < ApiApplicationController
    include Clearance::Authentication 
    skip_before_action :authenticate_request!
    

    # POST /authentication
    # POST /authentication.json
    #=begin
    # @api {post} /api/v1/auth_user 1-authenticate User and generate token
    # @apiVersion 0.3.0
    # @apiName AuthenticateUser
    # @apiGroup Authentication
    # @apiDescription User Authenticate.
    #
    # @apiExample Example usage: 
    # curl -X POST -d email="{Type Your Email}" -d password="{Type Your Password}" http://localhost:3000/api/v1/auth_user      
    # @apiSuccess {Integer}     id                   User's-ID.
    # @apiSuccess {String}      email                User's email.
    # @apiSuccess {String}     auth_token           User's authentication token.
    #
    # @apiSuccessExample Response (example):
    #     HTTP/ 200 OK
    #     {
    #       "success": "200 ok"
    #    }
    #
    # @apiError NoAccessRight Invalid Email/Password.
    #
    # @apiErrorExample Error-Response:
    #     HTTP/1.1 400 Bad Request
    #     {
    #       "error": "Invalid Email/Password"
    #    }
    #=end

    def authenticate
        @user = User.where("email =?",params[:email]).first
        if @user != nil 
            if @user.status == false
                render json: "Admin has disabled your account"
            elsif User.authenticate(params[:email],params[:password])
               render json: payload(@user)                   
            elsif !(User.authenticate(params[:email],params[:password]))                                                     
                render json: {errors: ['Invalid Email/Password']}, status: :unauthorized
            end
        else
            render json: {message: 'Invalid Email'}, status: :unauthorized
        end
    end    

    private

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


