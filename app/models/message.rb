class Message < ActiveRecord::Base
  belongs_to :user
  
  after_create :post_encoded
  
  require 'random_word_generator'
  
  private
    def post_encoded 
      
      
      self.code = RandomWordGenerator.composed(3, 15)
      self.save
      
      fb_user = FbGraph::User.me(self.user.fb_user_token.token)
      
      begin
      # something potentially bad
      
        fb_user.feed!(
          :message => "Code Message ##{self.id} : #{self.code}",
          :link => 'http://github.com/nov/fb_graph',
          :name => 'FbGraph',
          :description => 'A Ruby wrapper for Facebook Graph API'
        )
      rescue Exception=>e
      # handle e
      end
      
    end
  
end
