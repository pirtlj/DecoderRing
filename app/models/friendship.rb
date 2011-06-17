class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"

  include AASM

  aasm_column :status # defaults to aasm_state

  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :approved

  aasm_event :approve do
    transitions :to => :approved, :from => [:pending, :approved]
  end
  
end
