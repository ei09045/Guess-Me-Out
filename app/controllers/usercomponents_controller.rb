class UsercomponentsController < ApplicationController

  before_filter :save_login_state, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :authenticate_user, :except => [:getsvgs_android]

  # GET /usercomponents
  # GET /usercomponents.json
  def index
    @usercomponents = Usercomponent.all

    respond_to do |format|
      format.html # search.html.erb
      format.json { render json: @usercomponents }
    end
  end

  # GET /usercomponents/1
  # GET /usercomponents/1.json
  def show
    @usercomponent = Usercomponent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usercomponent }
    end
  end

  # GET /usercomponents/new
  # GET /usercomponents/new.json
  def new
    @usercomponent = Usercomponent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usercomponent }
    end
  end

  # GET /usercomponents/1/edit
  def edit
    @usercomponent = Usercomponent.find(params[:id])
  end

  # POST /usercomponents
  # POST /usercomponents.json
  def create
    @usercomponent = Usercomponent.new(params[:usercomponent])

    respond_to do |format|
      if @usercomponent.save
        format.html { redirect_to @usercomponent, notice: 'Usercomponent was successfully created.' }
        format.json { render json: @usercomponent, status: :created, location: @usercomponent }
      else
        format.html { render action: "new" }
        format.json { render json: @usercomponent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /usercomponents/1
  # PUT /usercomponents/1.json
  def update
    @usercomponent = Usercomponent.find(params[:id])

    respond_to do |format|
      if @usercomponent.update_attributes(params[:usercomponent])
        format.html { redirect_to @usercomponent, notice: 'Usercomponent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @usercomponent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usercomponents/1
  # DELETE /usercomponents/1.json
  def destroy
    @usercomponent = Usercomponent.find(params[:id])
    @usercomponent.destroy

    respond_to do |format|
      format.html { redirect_to usercomponents_url }
      format.json { head :no_content }
    end
  end
  
  
 
	
	def getsvgs_android
		respond_to do |format|
			
			@usercomponent = Usercomponent.find_by_sql("select componenttypes.id as id, componenttypes.color, componenttypes.svg, componenttypes.name,componenttypes.component_id from componenttypes, usercomponents where componenttypes.id=usercomponents.componenttype_id and componenttypes.component_id="+params[:componentid]+" and usercomponents.user_id="+params[:userid])
			format.json { render json: @usercomponent.to_json() }
		end	
	end
	
end
