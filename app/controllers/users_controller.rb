class UsersController < ApplicationController

  before_action :admin_only, only: [:index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
    #@users = User.all
    @users = User.all.paginate(page: params[:page], per_page: 10)
  end

	def show
    #@user = User.friendly.find(params[:id])
    #unless @user == current_user
    #  redirect_to :back, :alert => "Access denied."
    #end
	end

	def update
    @user = User.friendly.find(params[:id])
    if @user.update(secure_params)
      sign_in(@user == current_user ? @user : current_user, bypass: true)
      redirect_to @user, notice: "Your profile was successfully updated."
    else
      render "edit"
    end
	end

	def destroy
	  @user = User.find(params[:id])
	  @user.destroy
	  redirect_to users_path, :notice => "User deleted."
	end

	def following
	  @user = User.find(params[:id])
	  @users = @user.following.paginate(page: params[:page],per_page: 5)
	  render 'show_follow'
	end

	def followers
	  @title = "Followers"
	  @user = User.find(params[:id])
	  @users = @user.followers.paginate(page: params[:page],per_page: 5)
	  render 'show_follow'
	end


	private
 	def admin_only
    unless current_user.try(:admin?)
      redirect_to :back, :alert => "Access denied."
    end
  end

  def set_user
    @user = User.friendly.find params[:id]
  end
  
  def secure_params
    accessibles = [ :name, :email, :avatar ]
    #accessibles << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessibles)
  end
end
