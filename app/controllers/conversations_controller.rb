class ConversationsController < ApplicationController
  def create
    Conversation.create_or_find_by(user: Current.user)
  end

  def show
    @conversation = Current.user.conversation
  end
end
