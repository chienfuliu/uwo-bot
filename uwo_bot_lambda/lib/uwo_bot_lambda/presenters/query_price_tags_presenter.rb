# frozen_string_literal: true

module UwoBotLambda
  module Presenters
    class QueryPriceTagsPresenter < Base
      def ok(price_tag, price_tags, with_type: false)
        price_tag = ViewModels::PriceTag.new(price_tag) if price_tag
        price_tags = price_tags.map { |w| ViewModels::PriceTag.new(w) }
        if price_tag
          if with_type || price_tags.empty?
            show_only_exact_price_tag(price_tag)
          else
            show_exact_price_tag_with_others(price_tag, price_tags)
          end
        elsif !with_type && price_tags.size == 1
          show_first_candidate(price_tags)
        else
          show_possible_price_tags(price_tags)
        end
      end

      def argument_invalid
        @messenger.call(I18n.t('presenters.query_price_tags.argument_invalid'))
      end

      def not_found
        @messenger.call(I18n.t('presenters.query_price_tags.not_found'))
      end

      private

      def show_only_exact_price_tag(price_tag)
        @messenger.call(
          I18n.t(
            'presenters.query_price_tags.show_only_exact_price_tag',
            display_name: price_tag.display_name,
            price_table: price_table(price_tag)
          )
        )
      end

      def show_exact_price_tag_with_others(price_tag, price_tags)
        @messenger.call(
          I18n.t(
            'presenters.query_price_tags.show_exact_price_tag_with_others',
            display_name: price_tag.display_name,
            price_table: price_table(price_tag),
            other_price_tags: concatenate_possible_price_tags(price_tags)
          )
        )
      end

      def show_first_candidate(price_tags)
        price_tag = price_tags.first
        @messenger.call(
          I18n.t(
            'presenters.query_price_tags.show_first_candidate',
            display_name: price_tag.display_name,
            price_table: price_table(price_tag)
          )
        )
      end

      def show_possible_price_tags(price_tags)
        @messenger.call(
          I18n.t(
            'presenters.query_price_tags.show_possible_price_tags',
            other_price_tags: concatenate_possible_price_tags(price_tags)
          )
        )
      end

      def concatenate_possible_price_tags(price_tags)
        delimiter = I18n.t('presenters.common.delimiter')
        price_tags.map { |p| " `#{p.display_name}` " }.join(delimiter)
      end

      def price_table(price_tag)
        price_tag.price_table(
          price_value: I18n.t('presenters.common.price_value'),
          registered_at: I18n.t('presenters.common.registered_at')
        )
      end
    end
  end
end
