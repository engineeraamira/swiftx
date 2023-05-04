class Api::V1::UsersController < ApiApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_request!, only: [:create]

  # Register new account 
  # POST /users
  # =begin
  # @api {post} /api/v1/users/ 1-Register new User 
  # @apiVersion 0.3.0
  # @apiName registerUser
  # @apiGroup Users
  # @apiDescription register new user Only User Role can Register.
  # @apiExample Example usage:       
  # curl -X POST  http://localhost:3000/api/v1/users -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{"user": {"email": "{Type Your Email}", "password": "{Type Your Password}"}}' 
  # @apiBody {String}     email             User's Email
  # @apiBody {String}     password          User's Password
  #
  # @apiSuccess {Integer}     id                   User's-ID.
  # @apiSuccess {String}      email                User's email.
  #
  # @apiSuccessExample Response (example):
  #     HTTP/ 200 OK
  #     {
  #       "success": "200 ok"
  #    }
  #
  # @apiError MissingData invalid-data.
  # @apiErrorExample Error-Response:
  #     HTTP/1.1 400 Bad Request
  #     {
  #       "error": "Missing Data"
  #    }
  # =end
  def create
    begin
      @user = User.new(user_params)
      respond_to do |format|
        @user.user_group_id = 3
        if @user.save
          format.json { render json: @user, status: :created, location: @user }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    rescue =>e
      render json: e.message.to_s 
    end 
  end

  # Add new user 
  # POST /add_user
  # =begin
  # @api {post} /api/v1/add_user/ 2-Create new User 
  # @apiVersion 0.3.0
  # @apiName addUser
  # @apiGroup Users
  # @apiDescription Only Admin Or Managers Roles can Add Users.
  # @apiDescription Admin can Add Admin, Managers or Users.
  # @apiDescription Managers can Add Users.
  # @apiExample Example usage:       
  # curl -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ZHZ4wk8HgGiyYqalNY-JG9gBTUjsoAQqfTMLVrUYxTs" -X POST  http://localhost:3000/api/v1/add_user -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{"user": {"email": "{Type Your Email}", "password": "{Type Your Password}", "user_group_id": 3}}' 
  # @apiBody {String}     email             User's Email
  # @apiBody {String}     password          User's Password
  # @apiBody {Integer}    Role              User's Role can be 1,2 or 3
  #
  # @apiSuccess {Integer}     id                   User's-ID.
  # @apiSuccess {String}      email                User's email.
  # @apiSuccess {String}      Role                 User's Role.
  # @apiSuccess {Date} created_at  Date created.
  #
  # @apiSuccessExample Response (example):
  #     HTTP/ 200 OK
  #     {
  #       "success": "200 ok"
  #    }
  #
  # @apiError MissingData invalid-data.
  # @apiErrorExample Error-Response:
  #     HTTP/1.1 400 Bad Request
  #     {
  #       "error": "Missing Data"
  #    }
  # =end
  def add_user
    begin
      @user = User.new(user_params)
      respond_to do |format|
        if current_user.user_group_id != "Admin" && params[:user][:user_group_id] != "User"
          format.json { render json: "you are not allowed to add this user's role", status: :unprocessable_entity }
        else
          if @user.save
            format.json { render json: @user, status: :created, location: @user }
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    rescue =>e
      render json: "some thing went wrong "
    end 
  end

  # =begin
  # @api {put} /api/v1/users/:id 3-Update an existing user
  # @apiVersion 0.3.0
  # @apiName editUsers
  # @apiGroup Users
  # @apiExample Example usage:
  # curl -X PUT \
  # http://localhost:3000/api/v1/users/2 \
  # -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ZHZ4wk8HgGiyYqalNY-JG9gBTUjsoAQqfTMLVrUYxTs"
  # -H 'cache-control: no-cache' \
  # -H 'content-type: application/json' \
  # -d '{
  #   "email": "{Type User's email}",
  #   "password": "{Type User's password}",
  # }'
  # @apiHeader {String} Authorization user unique access key.
  # @apiParam {Number} id user unique id.
  # @apiBody {String} email user email.
  # @apiBody {String} password user's password.
  # @apiSuccess {Integer}     id                   User's-ID.
  # @apiSuccess {String}      email                User's email.
  # @apiSuccess {String}      user_group_id        User's Role.
  # @apiSuccess {Date}        created_at  Date created.
  # @apiSuccess {Date}        updated_at  Date Updated.
  # @apiSuccessExample Success-Response:
  # HTTP/1.1 200 OK
  # {
  #   "id": 2,
  #   "email": "x@example.com",
  #   "role": "User",
  #   "created_at": "2023-05-02T10:26:26.417Z",
  #   "updated_at": "2023-05-02T11:00:33.212Z"
  # }
  # @apiError MissingToken invalid token.
  # @apiErrorExample Error-Response1:
  # HTTP/1.1 400 Bad Request
  #   {
  #     "error": "Missing token"
  #   }
  # @apiError Invalid User id is not found.
  # @apiErrorExample Error-Response2:
  # HTTP/1.1 Invalid User
  #   {
  #     "message": "Couldn't find User with 'id'=2"
  #   }
  # =end
  
  def update
    begin
      respond_to do |format|
        if (current_user.user_group_id == "Admin" ||  current_user.id == params[:user][:id] || (current_user.user_group_id == "Manager" && @user.user_group_id != "Admin"))
          if @user.update(user_params)
            format.json { render json: @user, status: :ok, location: @user }
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        else
          format.json { render json: "you are not allowed to edit this user", status: :unprocessable_entity }
        end
      end
    rescue =>e
      render json: "some thing went wrong "
    end 
  end


  
  # =begin
  # @api {Delete} /api/v1/users/:id 4-Delete an existing user
  # @apiVersion 0.3.0
  # @apiName DeleteUser
  # @apiGroup Users
  # @apiExample Example usage:
  # curl -X DELETE \
  # http://localhost:3000/api/v1/users/3 \
  # -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.PFmF1-XVcJnU4gEa9FmBam-TLnd_Bk-OWMCnL8AOKHk"
  # @apiHeader {String} Authorization admin unique access key.
  # @apiParam {Number} id user unique id.
  # @apiSuccessExample Success-Response:
  # HTTP/1.1 200 OK
  # {
  #   "success": "User was successfully destroyed"
  # }
  # @apiError MissingToken invalid token.
  # @apiErrorExample Error-Response1:
  # HTTP/1.1 400 Bad Request
  #   {
  #     "error": "Missing token"
  #   }
  # @apiError InvalidUser id is not found.
  # @apiErrorExample Error-Response2:
  # HTTP/1.1 Invalid User
  #   {
  #     "message": "Couldn't find User with 'id'=5"
  #   }
  # =end

  def destroy
    begin 
      respond_to do |format|
        if (current_user.user_group_id == "Admin" || (current_user.user_group_id == "Manager" && @user.user_group_id == "User"))
          @user.update(deleted: true)
          format.json { render json: "user deleted successfully" }
        else
          format.json { render json: "you are not allowed to delete this user" }
        end
      end
    rescue =>e
      render json: "some thing went wrong "
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end 
  

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :status, :deleted)
    end
end
