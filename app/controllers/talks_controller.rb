class TalksController < ApplicationController
  def index
    @talks = Talk.where(room_id: params[:room_id])
    @new_talk = current_user.talks.build(room_id: params[:room_id])
    @active_users = Room.find(params[:room_id]).active_users
  end

  def create
    @talk = current_user.talks.build(params[:talk])
    if @talk.save
      redirect_to room_talks_url
    else
      redirect_to room_talks_url
    end
  end
  
  def destroy
    @talk = current_user.talks.in_the_room(params[:room_id]).find(params[:id])
    @talk.destroy

    redirect_to room_talks_url
  end
end
