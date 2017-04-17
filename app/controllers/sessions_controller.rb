class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']#our request translated from github and imniauth
    #raise
    user = User.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
    #if it's not there in the db then make it save it
    if user.nil?
      user = User.create_from_github(auth_hash)
      if user.nil?
        flash[:error] = "Could not login"
        redirect_to root_path
        # else
        #   #if it is there then save some data to session then redirect
        #   session[:user_id] = user.id
        #   flash[:success] = "Logged in Successfully"
        #   redirect_to root_path
      end
    end

    def login_form
    end

    def login
      username = params[:username]
      if username and user = User.find_by(username: username)
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as existing user #{user.username}"
      else
        user = User.new(username: username)
        if user.save
          session[:user_id] = user.id
          flash[:status] = :success
          flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
        else
          flash.now[:status] = :failure
          flash.now[:result_text] = "Could not log in"
          flash.now[:messages] = user.errors.messages
          render "login_form", status: :bad_request
          return
        end
      end
      redirect_to root_path
    end

    def logout
      session[:user_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out"
      redirect_to root_path
    end
  end
end
