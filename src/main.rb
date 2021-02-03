# frozen_string_literal: true

require_relative 'bot_service/bot'

begin
  service = UwoDictionaryBot::BotService::Bot.new
  service.register_commands.start
ensure
  service.stop
end
