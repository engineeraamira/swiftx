class Api::V1::UserLoginsController < ApiApplicationController
  before_action :set_user_login, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_request!, only: [:unlock_account]


  # after a number of failed login attempts, the user's account will be locked and link will be sent to user's mail. 
  # when the user clicks the link, he is redirected here to unlock the account and allow him to sign in again.
  # =begin
  # @api {post} /unlockaccount/ 8-unlock user account 
  # @apiVersion 0.3.0
  # @apiName unlockaccount
  # @apiGroup User
  # @apiDescription UnLock account after Number of failed attempts.
  # @apiParam {Integer}     user_id             User's Id
  # @apiParam {String}      token               User's token to unlock account
  #
  # @apiExample Example usage: 
  # curl -X POST  http://localhost:3000/api/v1/unlock-account -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{"id": 2,"token": "b28223f3"}' 
  #
  # @apiSuccessExample Response (example):
  #     HTTP/ 200 OK
  #     {
  #       "success": "200 ok"
  #    }
  #
  # @apiError required_parameter_missing wrong id.
  # @apiError required_parameter_missing2 wrong code.
  #
  # @apiErrorExample Error-Response:
  #     HTTP/1.1 400 Bad Request
  #     {
  #       "error": "Invalid account"
  #    }
  # @apiErrorExample Error-Response:
  #     HTTP/1.1 400 Bad Request
  #     {
  #       "error": "Invalid Token"
  #    }
  # =end


  def unlock_account
    begin
      @id = params[:id].to_i
      @token = params[:token]
      @user = User.where("id =?",@id ).first
      if  (@user != nil)
        if @token  == @user.unlock_token      
          @user.failed_attempts = 0
          @user.locked = false
          @user.unlock_token = nil
          @user.save
          render json:  {'result' => true} 
        else
          render json: {'result' => false, 'error' => 'Invalid Token'} 
        end
      else
        render json: {'result' => false, 'error' => 'Invalid Account'} 
      end
    rescue =>e
      @log =  ErrorLog.create(:user_id => @id,:message => e.message.to_s, :location => "user_logins/unlock_account") 
      render json: {'result' => false, 'error' => @log.message } 
    end 
  end

  
  


  # GET /user_logins
  # GET /user_logins.json
  def index
    @user_logins = UserLogin.all
  end

  # GET /user_logins/1
  # GET /user_logins/1.json
  def show
  end

  # GET /user_logins/new
  def new
    @user_login = UserLogin.new
  end

  # GET /user_logins/1/edit
  def edit
  end

  # POST /user_logins
  # POST /user_logins.json
  def create
    @user_login = UserLogin.new(user_login_params)

    respond_to do |format|
      if @user_login.save
        format.html { redirect_to @user_login, notice: 'User login was successfully created.' }
        format.json { render :show, status: :created, location: @user_login }
      else
        format.html { render :new }
        format.json { render json: @user_login.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_logins/1
  # PATCH/PUT /user_logins/1.json
  def update
    respond_to do |format|
      if @user_login.update(user_login_params)
        format.html { redirect_to @user_login, notice: 'User login was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_login }
      else
        format.html { render :edit }
        format.json { render json: @user_login.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_logins/1
  # DELETE /user_logins/1.json
  def destroy
    @user_login.destroy
    respond_to do |format|
      format.html { redirect_to user_logins_url, notice: 'User login was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_login
      @user_login = UserLogin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_login_params
      params.require(:user_login).permit(:user_id, :ip_address, :user_agent, :device_id, :operation_type, :email_token_sent_at)
    end
end
