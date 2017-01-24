class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include PublicActivity::StoreController
  before_action -> { doorkeeper_authorize! :api }, only: [:index, :show, :destroy]
  respond_to :json

# show error in response if unauthorized
  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "Not authorized" } }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: errors_json(e.message), status: :not_found
  end

  protected
  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id)
  end

  def is_creator?(event_id)
    event = Event.find(event_id)
    render json: { error: "You are not the creator of this event to do this action" } unless current_user == event.user
  end

  def is_participant?(event_id)
    participant_ids = Participant.where("event_id = ?", event_id).pluck(:user_id)
    render json: { error: "You are not the participant of this event" } unless participant_ids.include? current_user.id
  end

  private
  def errors_json(messages)
    { errors: [*messages] }
  end


end
