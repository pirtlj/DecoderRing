class HomeController < ApplicationController
  before_filter :authenticate_user!, :only =>[:bookmarklet]
  def landing
    if current_user
      redirect_to user_messages_path(current_user)
      return
    end
  end

  def bookmarklet
      respond_to do |format|
        format.js {} 
      end
  end
  
end
