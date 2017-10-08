class SemanticFieldsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @semantic_fields = SemanticField.all
  end
end
