class TalksController < ApplicationController
  def index
    @talks = Talk.where(room_id: params[:room_id])
    @new_talk = current_user.talks.build(room_id: params[:room_id])
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
    @talk = current_user.talks.find_by_id_and_room_id(params[:id], params[:room_id])
    @talk.destroy

    redirect_to room_talks_url
  end
end
