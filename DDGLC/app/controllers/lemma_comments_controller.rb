class LemmaCommentsController < ApplicationController
  load_and_authorize_resource

  def new
    @lemma_comment = LemmaComment.new
  end

  def create
    @lemma_comment = LemmaComment.new(lemma_comment_params)
    @lemma_comment.updated_by = current_user
    @lemma_comment.created_by = current_user
    @lemma_comment.updated_at = Time.now
    @lemma_comment.created_at = Time.now
    if @lemma_comment.save
      flash[:notice] = 'Comment saved.'
    else
      flash[:alert] = 'Comment could not be saved.'
    end
    redirect_to lemma_path(lemma_comment_params[:lemma_id])
  end

  def destroy
    @lemma_comment = LemmaComment.find(params[:id])
    @lemma_comment.delete
    redirect_to lemma_path(@lemma_comment.lemma)
  end

  private

  def lemma_comment_params
    params.require(:lemma_comment).permit(:content, :field, :lemma_id)
  end
end
