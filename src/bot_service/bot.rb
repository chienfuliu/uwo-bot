# frozen_string_literal: true

require 'discordrb'
require 'erb'
require 'i18n'
require 'mongo'
require 'yaml'
require_relative '../infrastructure/factories/word_factory'
require_relative '../infrastructure/repositories/word_repository'

module UwoDictionaryBot
  module BotService
    class Bot
      def initialize
        @configurations = {}

        load_initializers
        load_infrastructures
        initialize_bot
        register_commands
      end

      def start
        @bot.run
      end

      def stop
        @db_client&.close
        @bot.stop if @bot&.connected?
      end

      def env
        ENV.fetch('RACK_ENV', 'development')
      end

      private

      def load_initializers
        initializer_files = File.join('config', 'initializers', '**', '*.rb')
        Dir[initializer_files, base: __dir__].sort.each do |file|
          require_relative file
        end
      end

      def load_infrastructures
        connect_to_database unless @db_client

        @configurations[:word_repository] ||=
          Infrastructure::Repositories::WordRepository.new(@db_client)
        @configurations[:word_factory] ||=
          Infrastructure::Factories::WordFactory.new
      end

      def connect_to_database
        config_file = File.expand_path('config/database.yml', __dir__)
        db_config = YAML.safe_load(ERB.new(File.read(config_file)).result)[env]
        db_config.transform_keys!(&:to_sym)
        @db_client = Mongo::Client.new(Array(db_config.delete(:url)), db_config)
      end

      def initialize_bot
        @bot = Discordrb::Commands::CommandBot.new(
          token: ENV['DISCORD_BOT_TOKEN'],
          channels: Array(ENV['ALLOWED_CHANNELS']&.split(',') || []),
          prefix: COMMAND_PREFIX,
          command_doesnt_exist_message:
            I18n.t('commands.common.command_not_found', command: '%command%')
        )
      end

      def register_commands
        COMMAND_OPTIONS.each_key do |key|
          handler_class = COMMAND_OPTIONS[key].delete(:controller)
          @bot.command(key, **COMMAND_OPTIONS[key]) do |event, *args|
            handler = handler_class.new(
              messenger: event.method(:<<),
              **@configurations
            )
            handler.public_send(key, event, *args)
          end
        end
      end
    end
  end
end
