class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post
  
  def create
    @post = Post.find params[:post_id]
    @comment = @post.comments.new(comment_attributes)
    @comment.user = current_user

    if @comment.save
      flash[:success] = "comment created successfully."
    else
      flash[:warning] = "comment created errors"
    end
    redirect_to @post
  end
  #def create
  #  @post = post.find(params[:post_id])
  #  @comment = @post.comments.create(params[:comment])
  #  redirect_to post_path(@post)
  #end

  private
  def find_post
    @post = Post.find(params[:post_id] || params[:id])
    redirect_to root_path, flash[:warning] = "Access denied" unless @post
  end

  def comment_attributes
    params.require(:comment).permit([:content, :user_id, :post_id])
  end
end
