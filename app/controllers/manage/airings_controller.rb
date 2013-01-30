class Manage::AiringsController < ApplicationController
  before_filter :require_login
  before_filter :verify_ownership

  def create
    if params[:video_id]

      from = Airing.find(params[:video_id])
      video = from.video

      if (! Airing.exists?(:channel_id => @channel.id, :video_id => video.id))
        airing = Airing.create(:channel_id => @channel.id, :video_id => video.id, :parent_id => from.id)

        airing.go_live

        ChannelMailer.reaired(@channel, from.channel, video.title).deliver

        Activity.add :airing_restream,
          actor: from.parent.channel,
          subject: from,
          secondary_subject: from.channel

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
