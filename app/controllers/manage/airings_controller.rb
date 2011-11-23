class Manage::AiringsController < ApplicationController
  before_filter :require_login
  before_filter :verify_ownership
  
  def create
    
    if params[:video_id] && params[:from_id]

      from = Airing.find_by_channel_id_and_video_id(params[:from_id], params[:video_id])
      video = Video.find(params[:video_id])
      logger.info from
      logger.info video
      
      if ! Airing.exists?(:channel_id => @channel.id, :video_id => video.id) &&
        Airing.create(:channel_id => @channel.id, :video_id => video.id, :parent_id => from.id).go_live

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
  
  def destroy
    Airing.destroy(params[:id])
    redirect_to :back
  end
  
  private
    
    def verify_ownership
      @channel = Channel.find(params[:channel_id])
      current_user.owns?(@channel) 
    end
    
end
