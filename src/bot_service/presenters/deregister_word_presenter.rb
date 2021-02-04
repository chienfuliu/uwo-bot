# frozen_string_literal: true

require 'i18n'
require_relative '../view_models/word'
require_relative 'base'

module UwoDictionaryBot
  module BotService
    module Presenters
      class DeregisterWordPresenter < Base
        def ok(word)
          word = ViewModels::Word.new(word)
          @messenger.call(
            I18n.t('presenters.deregister_word.ok', word: word.display_name)
          )
        end

        def argument_invalid
          @messenger.call(I18n.t('presenters.deregister_word.argument_invalid'))
        end

        def word_not_found
          @messenger.call(I18n.t('presenters.deregister_word.word_not_found'))
        end

        def update_failed
          @messenger.call(I18n.t('presenters.deregister_word.update_failed'))
        end
      end
    end
  end
end
