class SublemmasController < ApplicationController
  load_and_authorize_resource

  def index
    @sublemmas = Sublemma.order(:id).page params[:page]
  end

  def show
    @sublemma = Sublemma.find(params[:id])
  end
end
