class Manage::AiringsController < ApplicationController
  before_filter :require_login
  before_filter :verify_ownership
  
  def create
    
    if params[:video_id] && params[:channel_id] && params[:from_id]

      from = Airing.find_by_channel_id_and_video_id(params[:from_id], params[:video_id])
      video = Video.find(params[:video_id])
      
      if (airing = Airing.create(:channel_id => @channel.id, :video_id => video.id, :parent_id => from.id)) &&
         airing.go_live

         ChannelMailer.reaired(airing.channel, from.channel, video.title)
         
         re = {
            :success => true,
            :channel_title => channel.title 
          }
      end
    
        
        re = {:success => false, :msg => "airing not created"}
      end
    
    else
      re = {:success => false, :msg => "not right params"}
    end

    render :json => re
  end
  
  
  private
    
    def verify_ownership
      @channel = Channel.find(params[:channel_id])
      current_user.owns?(channel) 
    end
end
