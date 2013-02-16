class Auth::RegistrationsController < ApplicationController
  before_filter :check_not_logged_in

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @code = params[:code] if params.key? :code
    @token = params[:token] if params.key? :token

    respond_to do |format|
      format.html {}
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    if !params.key?(:code) and !params.key?(:token)
      @user = User.new(params[:user])
      flash.now[:alert] = "Invalid Registration Code"
      render action: "new"
      return
    elsif params.key?(:code) and !InviteCode.not_used.exists?(code: params[:code])
      @user = User.new(params[:user])
      flash.now[:alert] = "Invalid Registration Code"
      render action: "new"
      return
    elsif params.key?(:token) and !ChannelInvite.exists?(token: params[:token])
      @user = User.new(params[:user])
      flash.now[:alert] = "You must have an invite"
      render action: "new"
      return
    end

    @user = User.new(params[:user])

    User.transaction do
      if @user.save
        if invite_code = InviteCode.where(code: params[:code]).first
          invite_code.use
          invite_code.user = @user
          invite_code.save
        end

        # create a primary channel
        @channel = @user.channels.create(:title => @user.username, :slug => @user.username)
        @user.primary_channel = @channel
        @user.save

        # subscribe user; happens last because it is the subscriber
        Channel.default.subscribed_by(@user)
      end
    end

    respond_to do |format|
      if @user.valid?
        auto_login(@user)
        flash[:new_user] = true
        format.html { redirect_back_or_to(manage_channel_path(@channel), :notice => 'Registration successful.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
