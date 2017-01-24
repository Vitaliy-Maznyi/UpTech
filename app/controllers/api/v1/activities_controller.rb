class Api::V1::ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: current_user.id, recipient_type: "User")
    render json: @activities, each_serializer: ActivitySerializer
  end

end
