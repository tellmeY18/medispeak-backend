class FormFieldsController < ApplicationController
  before_action :set_form_field, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /pages/1/form_fields
  def index
    @page = Page.find(params[:page_id])
    @pagy, @form_fields = pagy(@page.form_fields.sort_by_params(params[:sort], sort_direction))

    authorize @form_fields
  end

  # GET /form_fields/1 or /form_fields/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_form_field
    @form_field = FormField.find(params[:id])

    authorize @form_field
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
