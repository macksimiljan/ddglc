class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    has_layout = exception.subject.to_s != 'rails_admin'
    render template: "pages/not_authorized", status: 403, layout: has_layout
  end

end
