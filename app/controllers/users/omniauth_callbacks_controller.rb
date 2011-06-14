class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def method_missing(provider)
    # You need to implement the method below in your model
    
    if !User.omniauth_providers.index(provider).nil?
      omniauth = env["omniauth.auth"]
      @user = User.find_or_create_by_oauth(omniauth, current_user)
    
    
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'] 
        sign_in_and_redirect @user, :event => :authentication
      else
        #session["devise.facebook_data"] = env["omniauth.auth"]
        
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
      
    end
  end
  
end