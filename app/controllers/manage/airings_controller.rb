class Manage::AiringsController < ApplicationController
  before_filter :require_login
  before_filter :verify_ownership
  
  def create
    
    if params[:video_id] && params[:from_id]

      from = Airing.find_by_channel_id_and_video_id(params[:from_id], params[:video_id])
      video = Video.find(params[:video_id])
      logger.info from.id
      logger.info video.id
      logger.info @channel.id
      
      if (! Airing.exists?(:channel_id => @channel.id, :video_id => video.id))
        airing = Airing.create(:channel_id => @channel.id, :video_id => video.id, :parent_id => from.id)
        logger.info airing
        airing.go_live
        ChannelMailer.reaired(@channel, from.channel, video.title).deliver

        re = {
          :success => true,
          :channel_title => @channel.title 
        }
      else
    
        
        re = {:success => false, :msg => "already exists"}
      end
    
    else
      re = {:success => false, :msg => "not right params"}
    end
    logger.info re
    render :json => re
  end
  
  def archive
    @airing = Airing.find(params[:id])
    @airing.toggle_archive
    redirect_to :back
  end
  
  
  def destroy
    @channel.airings.destroy(params[:id])
    redirect_to :back
  end
  
  private
    
    def verify_ownership
      @channel = Channel.find(params[:channel_id])
      redirect_to root_path unless current_user.owns?(@channel) 
    end
    
end
