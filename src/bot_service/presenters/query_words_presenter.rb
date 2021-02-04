# frozen_string_literal: true

require 'i18n'
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
          @messenger.call(I18n.t('presenters.query_words.argument_invalid'))
        end

        def word_not_found
          @messenger.call(I18n.t('presenters.query_words.word_not_found'))
        end

        private

        def show_only_exact_word(word)
          @messenger.call(
            I18n.t(
              'presenters.query_words.show_only_exact_word',
              word: word.display_name,
              description: word.description
            )
          )
        end

        def show_exact_word_with_others(word, words)
          @messenger.call(
            I18n.t(
              'presenters.query_words.show_exact_word_with_others',
              word: word.display_name,
              description: word.description,
              other_words: concatenate_possible_words(words)
            )
          )
        end

        def show_first_candidate(words)
          word = words.first
          @messenger.call(
            I18n.t(
              'presenters.query_words.show_first_candidate',
              word: word.display_name,
              description: word.description
            )
          )
        end

        def show_possible_words(words)
          @messenger.call(
            I18n.t(
              'presenters.query_words.show_possible_words',
              other_words: concatenate_possible_words(words)
            )
          )
        end

        def concatenate_possible_words(words)
          words.map { |w| "`#{w.display_name}`" }.join(', ')
        end
      end
    end
  end
end
