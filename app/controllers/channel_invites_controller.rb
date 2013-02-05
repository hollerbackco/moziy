class ChannelInvitesController < ApplicationController
  def show
    @token = params[:token]
    @channel = invite.channel
    @user = invite.sender
  end

  def accept
    if logged_in?
      unless channel.member? current_user
        membership = channel.memberships.where(user_id: current_user.id).first_or_create

        flash[:notice] = "You have joined /#{channel.slug}"
      else
        flash[:notice] = "This member already belongs here"
      end
      redirect_to manage_channel_path(channel)
    else
      flash[:notice] = "Please make an account"
      redirect_to register_path(:from => params[:token])
    end
  end

  private

  def invite
    @invite ||= ChannelInvite.find_by_token params[:token]
  end

  def channel
    @channel ||= invite.channel
  end
end