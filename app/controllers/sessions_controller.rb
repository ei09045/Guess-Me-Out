class SessionsController < ApplicationController
 
	before_filter :authenticate_user, :except => [:index, :login, :login_attempt, :login_android, :notlogin_android, :login_attempt_android, :logout]
	before_filter :save_login_state, :only => [:index, :login, :login_attempt, :login_android, :notlogin_android, :login_attempt_android]

	def profile
		#Profile Page
    session[:saved_location] = "profile"
    @user = User.new(:admin =>@current_user.admin, :email =>@current_user.email, :name =>@current_user.name, :sex => @current_user.sex,:birthdate =>@current_user.birthdate, :location =>@current_user.location, :credits =>@current_user.credits)
  end

	def login
		#Login Form
	end
	
	def login_android
		@query=User.find_by_id(params[:id])
		respond_to do |format|
		format.json
		end
	end
	
	def notlogin_android
	  respond_to do |format|
		format.json{
		render :json => "{\"user\": \"false\"}"
    }
	  end
    end

	def login_attempt
		authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
		if authorized_user
			session[:user_id] = authorized_user.id
			session[:user_admin] = authorized_user.admin
			session[:user_name] = authorized_user.username
			session[:user_sex] = authorized_user.sex
      session[:user_credits] = authorized_user.credits
			session[:saved_location] = ""
			session[:user_birthdate] =authorized_user.birthdate
      user_avatar = Avatar.find_by_user_id(authorized_user.id)
      if user_avatar
        session[:user_avatar] = user_avatar.id
      else
        session[:user_avatar] = -1
      end
      flash[:notice] = "Welcome again, you logged in as #{authorized_user.username}"
      redirect_to(:controller=>'home', :action => 'home')


		else
			flash.now[:notice] = "Invalid Username or Password"
        	flash.now[:color]= "invalid"
			render "login"	
		end
	end
	
	def login_attempt_android
		respond_to do |format|
			authorized_user = User.authenticate(params[:email],params[:password])
			if authorized_user
				@user = User.find(authorized_user.id)
				@user.update_attribute(:authentication,SecureRandom.hex)
				session[:saved_location] = ""
				format.json{
					render :json => @user.to_json(:only=>[:id,:email,:name,:birthdate,:last_login,:sex,:credits,:location,:admin,:authentication])
				}
			else
				format.json{
					render :json => "{\"user\": \"false\"}"
				}
			end
		end
	end

	def logout
		session[:user_id] = nil
    session[:user_admin] = nil
    session[:user_name] = nil
    session[:user_sex] = nil
    session[:user_credits] = nil
    session[:saved_location] = nil
    session[:user_birthdate] = nil
    session[:user_avatar] = nil
		redirect_to :action => 'login'
	end

end
