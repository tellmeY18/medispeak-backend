class PagesController < ApplicationController
  before_action :set_page, only: [ :show ]

  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /templates/1/pages
  def index
    @template = Template.find(params[:template_id])
    @pagy, @pages = pagy(@template.pages.sort_by_params(params[:sort], sort_direction))

    authorize @template
  end

  # GET /pages/1 or /pages/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])

    authorize @page
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
