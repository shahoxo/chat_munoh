class TalksController < ApplicationController
  def index
    @talks = Talk.where(room_id: params[:room_id])
    @room_name = Room.find(params[:room_id]).title
  end
end
