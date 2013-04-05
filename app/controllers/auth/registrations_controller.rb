class Auth::RegistrationsController < ApplicationController
  before_filter :check_not_logged_in
  before_filter :check_for_mobile, :only => [:new]

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @token = params[:token] if params.key? :token

    respond_to do |format|
      format.html {}
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    User.transaction do
      if @user.save
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
        format.html { redirect_back_or_to(welcome_path, :notice => 'Registration successful.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
