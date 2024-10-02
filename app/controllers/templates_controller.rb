class TemplatesController < ApplicationController
  before_action :set_template, only: [:show]
  before_action :authenticate_user!

  # Uncomment to enforce Pundit authorization
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /templates
  def index
    @pagy, @templates = pagy(policy_scope(Template).sort_by_params(params[:sort], sort_direction))
    authorize @templates
  end

  # GET /templates/1 or /templates/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_template
    @template = Template.find(params[:id])
    authorize @template
  rescue ActiveRecord::RecordNotFound
    redirect_to templates_path
  end
end
