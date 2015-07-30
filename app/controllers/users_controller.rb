class UsersController < ApplicationController

	def index
    #@users = User.all
    @users = User.all.paginate(page: params[:page], per_page: 10)
  end

	def show
    @user = User.friendly.find(params[:id])
    #unless @user == current_user
    #  redirect_to :back, :alert => "Access denied."
    #end
	end

	def update
    @user = User.friendly.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
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

  def secure_params
    params.require(:user).permit(:role)
  end
end
