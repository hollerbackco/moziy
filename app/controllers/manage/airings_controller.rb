class Manage::AiringsController < ApplicationController
  before_filter :require_login
  
  def create
    
    channel = Channel.find(params[:channel_id])
    
    from = Airing.find_by_channel_id_and_video_id(params[:from_id], params[:video_id])
    
    if params[:video_id] && 
       (video = Video.find(params[:video_id])) &&
       current_user.owns?(channel) &&
       (airing = Airing.create(:channel_id => channel.id, :video_id => video.id, :parent_id => from.id)) &&
       airing.go_live
    end
    
    if airing.nil?
      re = {:success => false}
    else
      re = {
        :success => true,
        :channel_title => channel.title 
      }
      ChannelMailer.reaired(airing.channel, from.channel, video.title)
    end

    render :json => re
  end
  
  def destroy
    Airing.find(params[:id]).destroy
    redirect_to :back
  end


end
