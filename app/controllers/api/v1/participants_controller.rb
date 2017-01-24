class Api::V1::ParticipantsController < ApplicationController
  before_action only: [:create, :destroy] do |c|
    c.is_creator?(params[:event_id])
  end

  #POST /api/v1/events/:event_id/invite/:id
  def create
    @event = Event.find(params[:event_id])
    @user = User.find(params[:id])
    @participant = @event.participants.create(create_params)
    @participant.user_id = @user.id
    respond_to do |format|
      if @participant.save
        format.json { redirect_to api_v1_event_path, id: @event.id,  status: :created }
      else
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  #DELETE /api/v1/events/:event_id/expel/:id
  def destroy
    @event = Event.find(params[:event_id])
    @participant = @event.participants.find_by! user_id: params[:id]
    @participant.destroy
    render nothing: true, status: :ok
  end

  private
  def create_params
    params.permit(:event_id, :user_id)
  end
end
