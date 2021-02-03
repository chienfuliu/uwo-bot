# frozen_string_literal: true

require 'discordrb'
require_relative '../infrastructure/repositories/word_repository'
require_relative '../infrastructure/factories/word_factory'
require_relative 'controllers/words_controller'

module UwoDictionaryBot
  module BotService
    class Bot
      DATABASE_OPTIONS = {
        url: ['db'],
      }.freeze

      COMMAND_PREFIX = '!'

      COMMAND_OPTIONS = {
        ask: {
          description: 'Query a word and/or approximate words.',
          usage: 'ask [type_]name',
          min_args: 1,
          max_args: 1,
        },
        learn: {
          description: 'Learn a word.',
          usage: 'learn [type_]name description',
          min_args: 2,
          required_roles: Array(ENV['TRAINER_ROLE']),
        },
        forget: {
          description: 'Forget a word.',
          usage: 'forget [type_]name',
          min_args: 1,
          max_args: 1,
          required_roles: Array(ENV['TRAINER_ROLE']),
        },
      }.freeze

      attr_reader :configurations

      def initialize
        @bot = Discordrb::Commands::CommandBot.new(
          token: ENV['DISCORD_BOT_TOKEN'],
          channels: Array(ENV['ALLOWED_CHANNELS']&.split(',') || []),
          prefix: COMMAND_PREFIX
        )
        @configurations = {
          word_repository: Infrastructure::Repositories::WordRepository.new(**DATABASE_OPTIONS),
          word_factory: Infrastructure::Factories::WordFactory.new,
        }
      end

      def register_commands
        COMMAND_OPTIONS.each_key do |k|
          @bot.command(k, **COMMAND_OPTIONS[k]) do |event, *args|
            handler = Controllers::WordsController.new(
              messenger: event.method(:<<), **configurations
            )
            handler.public_send(k, event, *args)
          end
        end

        self
      end

      def start
        @bot.run
      end

      def stop
        @bot.stop if @bot.connected?
      end
    end
  end
end
