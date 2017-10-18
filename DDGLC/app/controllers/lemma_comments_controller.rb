class LemmaCommentsController < ApplicationController
  respond_to :html, :json

  def new

  end

  def create
  end

  private

  def comment_params
    params.require(:lemma_comment).permit(:content, :field, :lemma_id)
  end
end