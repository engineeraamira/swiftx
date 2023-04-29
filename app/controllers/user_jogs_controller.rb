class UserJogsController < ApplicationController
  before_action :set_user_jog, only: %i[ show edit update destroy ]

  # GET /user_jogs or /user_jogs.json
  def index
    if current_user.usergroup == "Admin"
      @user_jogs = UserJog.all
    else
      @user_jogs = UserJog.where(user: current_user.id).all
    end
  end

  # GET /user_jogs/1 or /user_jogs/1.json
  def show
  end

  # GET /user_jogs/new
  def new
    @user_jog = UserJog.new
  end

  # GET /user_jogs/1/edit
  def edit
  end

  # POST /user_jogs or /user_jogs.json
  def create
    @user_jog = UserJog.new(user_jog_params)

    respond_to do |format|
      if @user_jog.save
        format.html { redirect_to user_jog_url(@user_jog), notice: "User jog was successfully created." }
        format.json { render :show, status: :created, location: @user_jog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_jog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_jogs/1 or /user_jogs/1.json
  def update
    respond_to do |format|
      if @user_jog.update(user_jog_params)
        format.html { redirect_to user_jog_url(@user_jog), notice: "User jog was successfully updated." }
        format.json { render :show, status: :ok, location: @user_jog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_jog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_jogs/1 or /user_jogs/1.json
  def destroy
    @user_jog.destroy

    respond_to do |format|
      format.html { redirect_to user_jogs_url, notice: "User jog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_jog
      @user_jog = UserJog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_jog_params
      params.require(:user_jog).permit(:user_id, :jogging_date, :jogging_time, :distance, :created_by, :deleted, :deleted_by, :deleted_at, :)
    end
end
