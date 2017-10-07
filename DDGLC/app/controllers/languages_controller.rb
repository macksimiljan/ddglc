class LanguagesController < ApplicationController
  load_and_authorize_resource

  def index
    @languages = Language.all
  end
end
