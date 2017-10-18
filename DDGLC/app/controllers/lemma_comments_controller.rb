class LemmaCommentsController < ApplicationController
  respond_to :html, :json

  def new

  end

  def create
    @lemma_comment = LemmaComment.new(comment_params)
    @lemma_comment.updated_by = current_user
    @lemma_comment.created_by = current_user
    if @lemma_comment.save
      flash[:notice] = 'Comment saved.'
      redirect_to lemma_path(comment_params[:lemma_id])
    else
      flash[:alert] = 'Comment could not be saved.'
      redirect_to lemma_path(comment_params[:lemma_id])
    end
  end

  private

  def comment_params
    params.require(:lemma_comment).permit(:content, :field, :lemma_id)
  end
end