class UsageCommentsController < ApplicationController
  load_and_authorize_resource

  def new
    @usage_comment = UsageComment.new
  end

  def create
    @usage_comment = UsageComment.new(usage_comment_params)
    @usage_comment.updated_by = current_user
    @usage_comment.created_by = current_user
    if @usage_comment.save
      flash[:notice] = 'Comment saved.'
    else
      flash[:alert] = 'Comment could not be saved.'
    end
    redirect_to usage_path(usage_comment_params[:usage_id])
  end

  def destroy
    @usage_comment = UsageComment.find(params[:id])
    @usage_comment.delete
    redirect_to usage_path(@usage_comment.usage)
  end

  private

  def usage_comment_params
    params.require(:usage_comment).permit(:content, :field, :usage_id)
  end
end
