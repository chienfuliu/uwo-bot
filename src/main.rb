# frozen_string_literal: true

require_relative 'bot_service/bot'

begin
  service = UwoDictionaryBot::BotService::Bot.new
  service.start
ensure
  service&.stop
end
