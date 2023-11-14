class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to recipe_path(@comment.recipe.id)
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def destroy
  end
  
  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :recipe_id)
  end
end
