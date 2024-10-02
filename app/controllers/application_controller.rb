class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  include Sortable
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def pundit_user
    current_user
  end
end
