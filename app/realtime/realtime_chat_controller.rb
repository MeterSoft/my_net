class RealtimeChatController < FayeRails::Controller
  channel '/chat' do
    subscribe do
      created_at = if message['created_at'] && message['created_at'].size > 0
                     Time.parse(message['created_at'])
                   else
                     Time.now
                   end

      ChatMessage.new(message[:user_name] || '' + " : " + message['message'], created_at)
    end
  end
end
