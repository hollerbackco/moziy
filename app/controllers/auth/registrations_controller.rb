class Auth::RegistrationsController < ApplicationController
  before_filter :check_not_logged_in

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html {}
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if !InviteCode.not_used.exists?(code: params[:code])
      flash.now[:alert] = "Invalid Registration Code"
      render action: "new"
      return
    end

    invite_code = InviteCode.find(:first, conditions: {code: params[:code]})

    User.transaction do
      @user.save

      invite_code.use
      invite_code.user = @user
      invite_code.save

      # subscribe user
      Channel.default.subscribed_by(@user)

      # create a primary channel
      channel = @user.channels.create(:title => @user.username, :slug => @user.username)
      @user.primary_channel = channel
      @user.save
    end

    respond_to do |format|
      if @user.valid?
        auto_login(@user)
        format.html { redirect_to(manage_channel_path(channel), :notice => 'Registration successful.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
