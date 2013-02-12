class Manage::AiringsController < Manage::BaseController
  before_filter :set_channel, except: :show

  def show
    @airing = Airing.find(params[:id])
    set_title @airing.title
  end

  def create
    if params[:video_id]
      authorize! :add_airing, @channel

      from = Airing.find(params[:video_id])
      video = from.video

      if !Airing.exists?(:channel_id => @channel.id, :video_id => video.id)
        airing = Airing.create({
          :user_id => current_user.id,
          :channel_id => @channel.id,
          :video_id => video.id,
          :parent_id => from.id,
          :position => 0
        })

        ChannelMailer.reaired(@channel, from.channel, video.title).deliver

        Activity.add :airing_restream,
          actor: @channel,
          subject: from,
          secondary_subject: from.channel

        re = {
          :success => true,
          :channel_title => @channel.title,
          :channel_slug => @channel.slug
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
    authorize! :archive, @airing

    @airing.toggle_archive
    redirect_to :back
  end

  def destroy
    airing = @channel.airings.find params[:id]
    authorize! :destroy, airing
    airing.destroy
    redirect_to :back
  end

  private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end
end
