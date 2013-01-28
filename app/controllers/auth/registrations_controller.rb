class Auth::RegistrationsController < ApplicationController

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html { }# new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if !InviteCode.not_used.exists?(code: params[:code])
      render action: "new", notice: "invalid code"
      return
    end

    invite_code = InviteCode.find(:first, conditions: {code: params[:code]})

    respond_to do |format|
      if @user.save
        invite_code.use

        # subscribe user
        Channel.default.subscribed_by(@user)

        # create a primary channel
        @user.create_primary_channel(:title => @user.username, :slug => @user.username)

        auto_login(@user)
        format.html { redirect_to(manage_channel_path(channel), :notice => 'Registration successful. Check your email for activation instructions.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
