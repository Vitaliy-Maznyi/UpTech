class Api::V1::EventsController < ApplicationController
  before_action only: [:show] do |c|
    c.is_participant?(params[:id])
  end
  before_action only: [:update, :destroy] do |c|
    c.is_creator?(params[:id])
  end

  #GET /api/v1/events
  def index
    if request.GET.include? 'due'
      @events = Event.where("time BETWEEN ? AND ?", Time.current, Time.at(params[:due].to_i))
    else
      @events = Event.all
    end
    render json: @events, each_serializer: EventIndexSerializer, status: :ok
  end

  #GET /api/v1/events/:id
  def show
    @event = Event.find(params[:id])
    render json: @event, serializer: EventShowSerializer, status: :ok
  end

  #POST /api/v1/events
  def create
    @event = Event.new(event_params)
    @participant = @event.participants.new(user_id: current_user.id) #add creator user id to participants table
    @event.user_id = current_user.id if current_user
    respond_to do |format|
      if @participant.save
        format.json { redirect_to action: 'show', id: @event.id,  status: :created }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  #PATCH /api/v1/events/:id
  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update(event_update_params)
        format.json { redirect_to action: 'show', id: @event.id,  status: :ok }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  #DELETE /api/v1/events/:id
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    render nothing: true, status: :ok
  end

  private

  def event_params
    params.permit(:name, :time, :place, :purpose, :user_id)
  end

  def event_update_params
    params.permit(:name, :time, :place, :purpose)
  end
end
