class Manage::AiringsController < ApplicationController
  
  def create
    
    channel = Channel.find(params[:channel_id])
    
    if params[:video_id] && 
       (video = Video.find(params[:video_id])) &&
       current_user.owns?(channel) &&
       (airing = Airing.create(:channel_id => channel.id, :video_id => video.id)) &&
       airing.go_live
    end
    
    re = {
       :success => ! airing.nil?
      }
      
    render :json => re
  end
  
  def destroy
    Airing.find(params[:id]).destroy
    redirect_to :back
  end


end
