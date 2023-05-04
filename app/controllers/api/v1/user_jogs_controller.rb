class Api::V1::UserJogsController < ApiApplicationController
  before_action :set_user_jog, only: %i[ show edit update destroy ]

  # =begin
  # @api {get} /api/v1/user_jogs/:from_date/:to_date 1-Request UserJogs List
  # @apiHeader {String} Authorization Users unique access key.
  # @apiVersion 0.3.0
  # @apiName GetUserJogs
  # @apiGroup UserJogs
  # @apiExample Example usage:
  #curl -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ZHZ4wk8HgGiyYqalNY-JG9gBTUjsoAQqfTMLVrUYxTs" -i http://localhost:3000/api/v1/user_jogs?from_date="2023-05-01"\&to_date="2023-05-02"
  # @apiParam {Date}     from_date         filter by from date.
  # @apiParam {Date}     to_date           filter by to date.
  # @apiSuccess {Number} id user_jog       unique ID (Created automatically).
  # @apiSuccess {Number} user_id the       user unique id.
  # @apiSuccess {Date}   jogging_date      the jogging_date.
  # @apiSuccess {Time}   jogging_time      the jogging_time.
  # @apiSuccess {Float}  distance          the jogging distance.
  # @apiSuccess {Date}   created_at        Date created.
  # @apiSuccess {Date}   updated_at        Date Updated.
  # @apiSuccessExample Success-Response:
  # HTTP/1.1 200 OK
  # [
  # {
  #   "id": 1,
  #   "user_id": 3,
  #   "jogging_date": "2023-05-04",
  #   "jogging_time": "00:05:00",
  #   "distance":     "50",
  #   "created_by":     "1",
  #   "created_at": "2023-05-05T10:26:26.417Z",
  #   "updated_at": "2023-05-05T11:00:33.212Z"
  # }
  # {
  #   "id": 2,
  #   "user_id": 4,
  #   "jogging_date": "2023-05-01",
  #   "jogging_time": "00:30:00",
  #   "distance":     "80",
  #   "created_by":     "1",
  #   "created_at": "2023-05-05T10:26:26.417Z",
  #   "updated_at": "2023-05-05T11:00:33.212Z"
  # }
  # ]
  # @apiError MissingToken invalid token.
  # @apiErrorExample Error-Response:
  # HTTP/1.1 400 Bad Request
  #   {
  #     "error": "Missing token"
  #   }
  # =end

  def index
    begin 
      if ["Admin","Manager"].include? current_user.user_group_id
        @user_jogs = UserJog.where(deleted: false).all
      else
        @user_jogs = UserJog.where(user: current_user.id,deleted: false).all
      end
      if params[:from_date].present?
        @user_jogs =@user_jogs.where('jogging_date >= ?', params[:from_date])
      end
      if params[:to_date].present?
        @user_jogs = @user_jogs.where('jogging_date <= ?', params[:to_date])
      end
      render json: @user_jogs
    rescue =>e
      render json: "some thing went wrong "
    end
  end

  # =begin
  # @api {get} /api/v1/reports/:from_date/:to_date 5-Request UserJogs Report
  # @apiHeader {String} Authorization Users unique access key.
  # @apiVersion 0.3.0
  # @apiName GetUserJogsReport
  # @apiDescription retrieve users report with total jogging times in minutes and total distance in metre and the speed for each user filtered between any dates.
  # @apiGroup UserJogs
  # @apiExample Example usage:
  # curl -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ZHZ4wk8HgGiyYqalNY-JG9gBTUjsoAQqfTMLVrUYxTs" -i http://localhost:3000/api/v1/reports?from_date="2023-05-01"\&to_date="2023-05-02"
  # @apiParam {Date}     from_date                  filter by from date.
  # @apiParam {Date}     to_date                    filter by to date.
  # @apiSuccess {String} email                      user's email.
  # @apiSuccess {Float}  total_jogging_time         total_jogging_time
  # @apiSuccess {Float}  total_distance             total_distance.
  # @apiSuccess {Float}   total_speed_per_minute     total_speed_per_minute.
  # @apiSuccessExample Success-Response:
  # HTTP/1.1 200 OK
  #[
  #   {
  #     "user1@email.com":{
  #       "total_jogging_time":10.0,
  #       "total_distance":200:00,
  #       "total_speed_per_minute":20
  #     }
  #   },
  #   {
  #     "user2@email.com":{
  #       "total_jogging_time":10.0,
  #       "total_distance":100.0,
  #       "total_speed_per_minute":10
  #     }
  #   }
  # ]
  # @apiError MissingToken invalid token.
  # @apiErrorExample Error-Response:
  # HTTP/1.1 400 Bad Request
  #   {
  #     "error": "Missing token"
  #   }
  # =end

  def reports
    begin 
      if ["Admin","Manager"].include? current_user.user_group_id
        @users = User.where(deleted: false).all.includes(:user_jogs)
      else
        @users = User.where(user: current_user.id,deleted: false).includes(:user_jogs)
      end
      @result = []
      @users.each do |user|
        @jogs = user.user_jogs.where(deleted: false)
        if params[:from_date].present?
          @jogs = @jogs.where('jogging_date >= ?', params[:from_date])
        end
        if params[:to_date].present?
          @jogs = @jogs.where('jogging_date <= ?', params[:to_date])
        end
        @user = {}
        @user_jogs_distances = @jogs.where(deleted: false).pluck("SUM(distance)")
        @user_jogs_times = @jogs.where(deleted: false).pluck("jogging_time").map { |e| e.strftime("%H:%M:%S")}
        #@user_jogs = user.user_jogs.where(deleted: false).pluck("jogging_time", "SUM(distance)").map { |e| [ e[0].strftime("%H:%M:%S"), e[1] ]}
          size = @user_jogs_times.size
          total_minutes = 0
          avg_minutes = @user_jogs_times.map do |x|
            hour, minute, seconds = x.split(':')
            total_minutes += hour.to_f * 60 + minute.to_f + (seconds.to_f/60)
          end
          @user_speed = (total_minutes > 0)? @user_jogs_distances[0]/total_minutes.to_f : 0
          @user[user.email] = {"total_jogging_time" => total_minutes.to_f, "total_distance"=> @user_jogs_distances[0], "total_speed_per_minute"=> @user_speed}
          @result << @user
      end

      render json: @result
    rescue =>e
      render json: "some thing went wrong "
    end
  end

  # Create new user_jogs 
  # POST /user_jogs
  # =begin
  # @api {post} /api/v1/user_jogs/ 2-Create new User Jog
  # @apiVersion 0.3.0
  # @apiName Create UserJog
  # @apiGroup UserJogs
  # @apiDescription create new user jog.
  # @apiDescription users can add record for themselves, Managers can add records for users, Admin can add records for users or managers.
  # @apiExample Example usage:       
  # curl -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ZHZ4wk8HgGiyYqalNY-JG9gBTUjsoAQqfTMLVrUYxTs" -X POST  http://localhost:3000/api/v1/user_jogs -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{"user_jogs": {"user_id": "{Type User Id}", "jogging_date": "{Type Jogging Date}", "jogging_time": "{Type Jogging Time}", "distance": "{Type Jogging Distance}"}}' 
  # @apiBody {Integer}    user_id           User's ID
  # @apiBody {Date}       jogging_date      User's Jogging Date
  # @apiBody {Time}       jogging_time      User's Jogging Time
  # @apiBody {Float}      distance          User's Jogging Distance
  #
  # @apiSuccess {Integer}     id                     User's-ID.
  # @apiSuccess {Date}        jogging_date           User's Jogging Date.
  # @apiSuccess {Time}        jogging_time           User's Jogging Time
  # @apiSuccess {Float}       distance               User's Jogging Distance
  # @apiSuccess {Date}        created_at             Date created.
  # @apiSuccess {integer}     created_by             Who created the record.
  #
  # @apiSuccessExample Response (example):
  # HTTP/1.1 200 OK
  # {
  #   "id": 2,
  #   "user_id": 2,
  #   "jogging_date": "2023-05-05",
  #   "jogging_time": "10:00:00",
  #   "distance":     "32",
  #   "created_by":     "1",
  #   "created_at": "2023-05-05T10:26:26.417Z",
  #   "updated_at": "2023-05-05T11:00:33.212Z"
  # }
  #
  # @apiError MissingData invalid-data.
  # @apiErrorExample Error-Response:
  #     HTTP/1.1 400 Bad Request
  #     {
  #       "error": "Missing Data"
  #    }
  # =end
  # @apiError MissingToken invalid token.
  # @apiErrorExample Error-Response1:
  # HTTP/1.1 400 Bad Request
  #   {
  #     "error": "Missing token"
  #   }
  def create
    begin
      @user_jog = UserJog.new(user_jog_params)
      if ["Admin","Manager"].include? current_user.user_group_id
        @user_jog.user_id = params[:user_jog][:user_id]
      else
        @user_jog.user_id = current_user.id
      end
      respond_to do |format|
        if (current_user.user_group_id == "Admin" || current_user.id == @user_jog.user_id || (current_user.user_group_id == "Manager" && @user_jog.user.user_group_id != "Admin"))
          @user_jog.created_by = current_user.id
          if @user_jog.save
            format.json { render json: @user_jog, status: :created}
          else
            format.json { render json: @user_jog.errors, status: :unprocessable_entity }
          end
        else
          format.json { render json: "you are not allowed to create this record", status: :unprocessable_entity }
        end
      end
    rescue =>e
      render json: "some thing went wrong "
    end
  end

  # =begin
  # @api {put} /api/v1/user_jogs/:id 3-Update an existing user_jog
  # @apiVersion 0.3.0
  # @apiName editUserJog
  # @apiGroup UserJogs
  # @apiExample Example usage:
  # curl -X PUT \
  # http://localhost:3000/api/v1/user_jog/2 \
  # -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ZHZ4wk8HgGiyYqalNY-JG9gBTUjsoAQqfTMLVrUYxTs"
  # -H 'cache-control: no-cache' \
  # -H 'content-type: application/json' \
  # -d '{
  #   "user_id":      "{Type UserJog's UserId}",
  #   "jogging_date": "{Type UserJog's Date}",
  #   "jogging_time": "{Type UserJog's Time}",
  #   "distance":     "{Type UserJog's Distance}",
  # }'
  # @apiHeader {String} Authorization user unique access key.
  # @apiParam {Number}    id                user_jog unique id.
  # @apiBody {Integer}    user_id           User's ID
  # @apiBody {Date}       jogging_date      User's Jogging Date
  # @apiBody {Time}       jogging_time      User's Jogging Time
  # @apiBody {Float}      distance          User's Jogging Distance
  # @apiSuccess {Integer}     id                     User's-ID.
  # @apiSuccess {Date}        jogging_date           User's Jogging Date.
  # @apiSuccess {Time}        jogging_time           User's Jogging Time
  # @apiSuccess {Float}       distance               User's Jogging Distance
  # @apiSuccess {Date}        created_at             Date created.
  # @apiSuccess {integer}     created_by             Who created the record.
  # @apiSuccess {Date}        updated_at             Date Updated.
  # @apiSuccessExample Success-Response:
  # HTTP/1.1 200 OK
  # {
  #   "id": 2,
  #   "user_id": 2,
  #   "jogging_date": "2023-05-05",
  #   "jogging_time": "10:00:00",
  #   "distance":     "32",
  #   "created_by":     "1",
  #   "created_at": "2023-05-05T10:26:26.417Z",
  #   "updated_at": "2023-05-05T11:00:33.212Z"
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
  #     "message": "Couldn't find UserJog with 'id'=2"
  #   }
  # =end
  def update
    begin
      if ["Admin","Manager"].include? current_user.user_group_id
        @user_jog.user_id = params[:user_jog][:user_id]
      else
        @user_jog.user_id = current_user.id
      end
      respond_to do |format|
        if (current_user.user_group_id == "Admin" || current_user.id == @user_jog.user_id || (current_user.user_group_id == "Manager" && @user_jog.user.user_group_id != "Admin"))
          if @user_jog.update(user_jog_params)
            format.json { render json: @user_jog, status: :ok, message: "User jog was successfully updated." }
          else
            format.json { render json: @user_jog.errors, status: :unprocessable_entity }
          end
        else
          format.json { render json: "you are not allowed to edit this record", status: :unprocessable_entity }
        end
      end
    rescue =>e
      render json: "some thing went wrong "
    end
  end
  
  # =begin
  # @api {Delete} /api/v1/user_jogs/:id 4-Delete an existing user_jog
  # @apiVersion 0.3.0
  # @apiName DeleteUserJog
  # @apiGroup UserJogs
  # @apiExample Example usage:
  # curl -X DELETE \
  # http://localhost:3000/api/v1/user_jogs/3 \
  # -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.PFmF1-XVcJnU4gEa9FmBam-TLnd_Bk-OWMCnL8AOKHk"
  # @apiHeader {String} Authorization admin unique access key.
  # @apiParam {Number} id user_jogs unique id.
  # @apiSuccessExample Success-Response:
  # HTTP/1.1 200 OK
  # {
  #   "success": "UserJog was successfully destroyed"
  # }
  # @apiError MissingToken invalid token.
  # @apiErrorExample Error-Response1:
  # HTTP/1.1 400 Bad Request
  #   {
  #     "error": "Missing token"
  #   }
  # @apiError InvalidUserJog id is not found.
  # @apiErrorExample Error-Response2:
  # HTTP/1.1 Invalid User
  #   {
  #     "message": "Couldn't find UserJog with 'id'=5"
  #   }
  # =end
  def destroy
    begin 
      respond_to do |format|
        if (current_user.user_group_id == "Admin" || current_user.id == @user_jog.user_id || (current_user.user_group_id == "Manager" && @user_jog.user.user_group_id != "Admin"))
          @user_jog.update(deleted: true, deleted_by: current_user.id, deleted_at: Time.now)
          format.json { render json: "userJog deleted successfully" }
        else
          format.json { render json: "you are not allowed to delete this user_jog" }
        end
      end
    rescue =>e
      render json: "some thing went wrong "
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_jog
      @user_jog = UserJog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_jog_params
      params.require(:user_jog).permit(:user_id, :jogging_date, :jogging_time, :distance, :created_by, :deleted, :deleted_by, :deleted_at)
    end
end
