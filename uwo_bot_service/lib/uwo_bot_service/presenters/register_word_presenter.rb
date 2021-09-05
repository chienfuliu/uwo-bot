# frozen_string_literal: true

module UwoBotService
  module Presenters
    class RegisterWordPresenter < Base
      def ok(word)
        word = ViewModels::Word.new(word)
        @messenger.call(
          I18n.t('presenters.register_word.ok', display_name: word.display_name)
        )
      end

      def argument_invalid
        @messenger.call(I18n.t('presenters.register_word.argument_invalid'))
      end

      def update_failed
        @messenger.call(I18n.t('presenters.register_word.update_failed'))
      end
    end
  end
end
