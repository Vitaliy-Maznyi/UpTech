class Api::V1::EventsController < ApplicationController
  before_action only: [:show] { |c| c.is_participant?(params[:id]) }
  before_action only: [:update, :destroy] { |c| c.is_creator?(params[:id]) }
  before_action :set_event, only: [:show, :update, :destroy]

  #GET /api/v1/events
  def index
    if request.GET.include? 'due'
      @events = Event.where("time BETWEEN ? AND ?", Time.current, Time.at(params[:due].to_i))
    else
      @events = Event.all.order("id desc")
    end
    render json: @events, each_serializer: EventIndexSerializer, status: :ok
  end

  #GET /api/v1/events/:id
  def show
    render json: @event, serializer: EventShowSerializer, status: :ok
  end

  #POST /api/v1/events
  def create
    @event = Event.new(event_params)
    @participant = @event.participants.new(user_id: current_user.id) #add creator user id to participants table
    @event.user_id = current_user.id if current_user
    if @event.save
      redirect_to action: 'show', id: @event.id,  status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  #PATCH /api/v1/events/:id
  def update
    if @event.update(event_update_params)
      redirect_to action: 'show', id: @event.id,  status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  #DELETE /api/v1/events/:id
  def destroy
    @event.destroy
    render nothing: true, status: :ok
  end

  private
  def event_params
    params.permit(:name, :time, :place, :purpose, :user_id, :image)
  end

  def event_update_params
    params.permit(:name, :time, :place, :purpose, :image)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
