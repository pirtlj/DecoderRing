class Message < ActiveRecord::Base
  belongs_to :user
  
  after_create :post_encoded
  
  require 'random_word_generator'
  
  
  class << self
    public  
      def code_regex
        "/(?!Code #)\\b\\d+\\b(?= :)/"
      end
    
  end
  
  public  
    def encoded
      "Code ##{self.id} : #{self.code}"
    end
  
  private
    def post_encoded 
          
      self.code = RandomWordGenerator.composed(3, 15)
      self.save
      
      fb_user = FbGraph::User.me(self.user.fb_user_token.token)
      
      fb_user.feed!(
        :message => self.encoded,
        :link => 'http://github.com/nov/fb_graph',
        :name => 'FbGraph',
        :description => 'A Ruby wrapper for Facebook Graph API'
      )
      
    end
  
end
