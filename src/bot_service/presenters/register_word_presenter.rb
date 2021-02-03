# frozen_string_literal: true

require_relative '../view_models/word'
require_relative 'base'

module UwoDictionaryBot
  module BotService
    module Presenters
      class RegisterWordPresenter < Base
        def ok(word)
          word = ViewModels::Word.new(word)
          @messenger.call("Successfully learned `#{word.display_name}`.")
        end

        def argument_invalid
          @messenger.call('Argument invalid.')
        end

        def word_not_found
          @messenger.call('Not found.')
        end

        def update_failed
          @messenger.call('Update failed.')
        end
      end
    end
  end
end
