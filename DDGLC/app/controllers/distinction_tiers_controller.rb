class DistinctionTiersController < ApplicationController
  load_and_authorize_resource

  def index
    @distinction_tiers = DistinctionTier.all
  end
end
