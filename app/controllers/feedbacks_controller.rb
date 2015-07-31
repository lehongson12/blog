class FeedbacksController < ApplicationController

	def index
		@feedbacks = Feedback.all	
	end

	def new
		@feedback = Feedback.new
	end

	def create
    @feedback = Feedback.new(feedback_attributes)

    if @feedback.save
      flash[:success] = "comment created successfully."
    else
      flash[:warning] = "comment created errors"
      render "new"
    end
    redirect_to @post
	end

	private

  def comment_attributes
    params.require(:comment).permit([:name, :email, :comment])
  end
end
