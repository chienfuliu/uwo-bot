# frozen_string_literal: true

require_relative '../view_models/word'
require_relative 'base'

module UwoDictionaryBot
  module BotService
    module Presenters
      class QueryWordsPresenter < Base
        def ok(word, words, with_type: false)
          word = ViewModels::Word.new(word) if word
          words = words.map { |w| ViewModels::Word.new(w) }
          if word
            if with_type || words.empty?
              show_only_exact_word(word)
            else
              show_exact_word_with_others(word, words)
            end
          elsif !with_type && words.size == 1
            show_first_candidate(words)
          else
            show_possible_words(words)
          end
        end

        def argument_invalid
          @messenger.call('Argument invalid.')
        end

        def word_not_found
          @messenger.call('Not found.')
        end

        private

        def show_only_exact_word(word)
          @messenger.call("I got `#{word.display_name}`.")
          @messenger.call(word.description)
        end

        def show_exact_word_with_others(word, words)
          @messenger.call("I got `#{word.display_name}`.")
          @messenger.call(word.description)
          @messenger.call("I also got: #{concatenate_possible_words(words)}")
        end

        def show_first_candidate(words)
          word = words.first
          @messenger.call("I got only one similar result: `#{word.display_name}`.")
          @messenger.call(word.description)
        end

        def show_possible_words(words)
          @messenger.call(
            <<~MESSAGE
              No exact word found. Do you mean: \
              #{concatenate_possible_words(words)}.
            MESSAGE
          )
        end

        def concatenate_possible_words(words)
          words.map { |w| "`#{w.display_name}`" }.join(', ')
        end
      end
    end
  end
end
