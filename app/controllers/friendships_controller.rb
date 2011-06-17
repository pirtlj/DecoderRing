class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /friendships
  # GET /friendships.xml
  def index
    
    @requested_friendships = current_user.requested_friendships
    
    @pending_friendships = current_user.pending_friendships
    
    @friendships = current_user.friendships
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @friendships }
    end
  end

  # GET /friendships/1
  # GET /friendships/1.xml
  def show
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @friendship }
    end
  end

  # GET /friendships/new
  # GET /friendships/new.xml
  def new
    @friendship = Friendship.new(:user_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @friendship }
    end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
  end

  # POST /friendships
  # POST /friendships.xml
  def create
    @friendship = current_user.direct_friendships.build(params[:friendship])

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to(friendships_path, :notice => 'Friendship was successfully created.') }
        format.xml  { render :xml => @friendship, :status => :created, :location => @friendship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @friendship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /friendships/1
  # PUT /friendships/1.xml
  def update
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      if @friendship.update_attributes(params[:friendship])
        format.html { redirect_to(@friendship, :notice => 'Friendship was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @friendship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.xml
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to(friendships_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
      @friendship = current_user.inverse_friendships.find(params[:id])
      @friendship.approve!
      
      redirect_to(friendships_url, :notice => 'Friendship was successfully approved.')
  end
end
