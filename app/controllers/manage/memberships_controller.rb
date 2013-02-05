class Manage::MembershipsController < Manage::BaseController

  def index
    @members = channel.members
  end

  # invitation
  def create
    @invitation = ChannelInvite.where(
      channel_id: channel.id,
      sender_id: user.id,
      recepient_email: params[:email]
    ).first_or_create

    respond_to do |format|
      if @invitation.valid?
        format.html do
          flash[:notice] = "Sent an email to #{params[:email]}."
          redirect_to manage_channel_memberships_path channel
        end
      else
        format.html do
          flash[:notice] = "There was an error adding #{params[:email]}"
          redirect_to manage_channel_memberships_path channel
        end
      end
    end
  end

  def destroy
    membership.destroy
    flash[:notice] = "Member has been removed"
    redirect_to :back
  end

  private

  def user
    @user ||= current_user
  end

  def channel
    @channel ||= Channel.find(params[:channel_id])
  end

  def membership
    @membership ||= @channel.memberships.where(:user_id => params[:id]).first
  end

end
