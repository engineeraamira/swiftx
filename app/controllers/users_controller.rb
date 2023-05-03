class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :require_login, only: %i[ create new ]

  # GET /users or /users.json
  def index
    if ["Admin","Manager"].include? current_user.user_group_id 
      @users = User.where(deleted: false).all
    else
      redirect_to root_path, notice: "you are not allowed to view this page"
    end
  end

  # GET /users/1 or /users/1.json
  def show
  end

  def home
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def add_new
    if ["Admin","Manager"].include? current_user.user_group_id 
      @user = User.new
    else
      redirect_to root_path
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        if current_user.present?
          format.html { render :add_new, status: :unprocessable_entity }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :user_group_id, :status, :deleted)
    end
end
