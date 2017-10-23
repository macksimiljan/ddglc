class UsageCategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @usage_categories = UsageCategory.all
  end
end
