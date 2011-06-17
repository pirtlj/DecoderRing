class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :authentication_token

  
  has_many :user_tokens, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  
  #friend relations
  
  has_many :direct_friendships, :class_name => "Friendship"
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  
  has_many :direct_friends, :through => :direct_friendships, :conditions => "status => :approved", :source => :friend
  has_many :inverse_friends, :through => :inverse_friendships, :conditions => "status = approved", :source => :user

  has_many :pending_friends, :through => :direct_friendships, :conditions => "friendships.status = 'pending'", :foreign_key => "friend_id", :source => :user
  has_many :requested_friendships, :class_name => "Friendship", :foreign_key => "user_id", :conditions => "friendships.status = 'pending'"

  def friends
    direct_friends | inverse_friends
  end
  
  def friendships
    direct_friendships.where(:status => "approved") | inverse_friendships.where(:status => "approved") 
  end
  
  
  
  # Class Methods
   
  class << self
    
    public
    
    def find_or_create_by_oauth(omniauth, signed_in_resource=nil)
      data = omniauth['extra']['user_hash']
      
      
      if user = User.find_by_email(data["email"])
        
      else # Create a user with a stub password. 
        user = User.create!(:email => data["email"],
                            :password => Devise.friendly_token[0,20],
                            :authentication_token => Devise.friendly_token[0,20]) 
      end
      
      user.apply_omniauth(omniauth)
      
      return user
    end
    
  end
  
  
  #Instance Methods
  
  def apply_omniauth(omniauth)
    #add some info about the user
    #self.name = omniauth['user_info']['name'] if name.blank?
    #self.nickname = omniauth['user_info']['nickname'] if nickname.blank?
    
    user_tokens.where(:provider => omniauth['provider']).all.each{|token| token.destroy}
      
    unless omniauth['credentials'].blank?
      user_tokens.build(:provider => omniauth['provider'], 
                        :uid => omniauth['uid'],
                        :token => omniauth['credentials']['token'], 
                        :secret => omniauth['credentials']['secret'])
    else
      user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    end
    
  end
  
  def fb_user_token
    user_tokens.where(:provider => "facebook").first
  end
  
  def fb_avatar
    if fb_user_token
      FbGraph::User.fetch(fb_user_token.uid).picture
    end
  end

end
