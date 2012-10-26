class RoomsController < ApplicationController
  before_filter :find_room, only: [:edit, :update, :destroy]

  def index
    @rooms = Room.all
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(params[:room])

    if @room.save
      redirect_to rooms_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update_attributes(params[:room])
      redirect_to rooms_url
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_url
  end

  private
  def find_room
    @room = current_user.rooms.find(params[:id])
  end
end
