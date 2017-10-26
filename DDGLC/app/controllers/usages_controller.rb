class UsagesController < ApplicationController
  load_and_authorize_resource

  def index
    @usages = Usage.order(:sublemma_id, :id).page params[:page]
  end

  def show
    @usage = Usage.find(params[:id])
  end
end