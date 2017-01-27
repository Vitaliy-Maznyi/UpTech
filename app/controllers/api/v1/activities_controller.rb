class Api::V1::ActivitiesController < Api::BaseController
  before_action -> { doorkeeper_authorize! :api }
  def index
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: current_user.id, recipient_type: "User")
    render json: @activities, each_serializer: ActivitySerializer
  end
end
