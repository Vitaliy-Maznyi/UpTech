class Api::V1::CommentsController < ApplicationController
  before_action only: [:create] {|c| c.is_participant?(params[:event_id]) }
  before_action only: [:destroy] { |c| c.is_creator?(params[:event_id]) }
  before_action :set_event

  #POST /api/v1/events/:event_id/comments
  def create
    @comment = @event.comments.create(comment_params)
    @comment.user_id = current_user.id if current_user
    if @comment.save
      @comment.create_activity :create, recipient: @event.user, owner: current_user
      redirect_to api_v1_event_path, id: @event.id,  status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  #DELETE /api/v1/events/:event_id/comments/:id
  def destroy
    @comment = @event.comments.find(params[:id])
    @comment.create_activity :destroy, recipient: @event.user, owner: current_user
    @comment.destroy
    render nothing: true, status: :ok
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def comment_params
    params.permit(:content, :user_id, :image)
  end
end
