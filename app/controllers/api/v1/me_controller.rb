class Api::V1::MeController < Api::BaseController
  def show
    render json: current_user.to_json
  end

  def destroy
    current_user.destroy
    render json: {}
  end
end
