class TranscriptionsController < ApplicationController
  before_action :authenticate_user!

  # Uncomment to enforce Pundit authorization
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /transcriptions
  def index
    @pagy, @transcriptions = pagy(policy_scope(Transcription).sort_by_params(params[:sort], sort_direction))
    authorize @transcriptions
  end
end
