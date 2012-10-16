class RoomsController < ApplicationController
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
    @room = current_user.rooms.find(params[:id])
  end
end
