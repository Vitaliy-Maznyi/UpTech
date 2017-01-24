class Api::V1::CommentsController < ApplicationController
  before_action only: [:create] do |c|
    c.is_participant?(params[:event_id])
  end
  before_action only: [:destroy] do |c|
    c.is_creator?(params[:event_id])
  end

  #POST /api/v1/events/:event_id/comments
  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.create(comment_params)
    @comment.user_id = current_user.id if current_user
    respond_to do |format|
      if @comment.save
        @comment.create_activity :create, recipient: @event.user, owner: current_user
        format.json { redirect_to api_v1_event_path, id: @event.id,  status: :created }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  #DELETE /api/v1/events/:event_id/comments/:id
  def destroy
    @event = Event.find(params[:event_id])
    @comment = @event.comments.find(params[:id])
    @comment.create_activity :destroy, recipient: @event.user, owner: current_user
    @comment.destroy
    render nothing: true, status: :ok
  end

  private
  def comment_params
    params.permit(:content, :user_id)
  end
end
