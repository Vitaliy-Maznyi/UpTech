class Api::V1::ParticipantsController < Api::BaseController
  before_action only: [:create, :destroy] { |c| c.is_creator?(params[:event_id]) }
  before_action :set_event

  #POST /api/v1/events/:event_id/invite/:id
  def create
    @user = User.find(params[:id])
    @participant = @event.participants.create(create_params)
    @participant.user_id = @user.id
    if @participant.save
      redirect_to api_v1_event_path, id: @event.id,  status: :created
    else
      render json: @participant.errors, status: :unprocessable_entity
    end
  end

  #DELETE /api/v1/events/:event_id/expel/:id
  def destroy
    @participant = @event.participants.find_by! user_id: params[:id]
    @participant.destroy
    render nothing: true, status: :ok
  end

  private
  def create_params
    params.permit(:event_id, :user_id)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
