# frozen_string_literal: true

module UwoBotLambda
  module Presenters
    class RegisterPriceTagPresenter < Base
      def ok(price_tag)
        price_tag = ViewModels::PriceTag.new(price_tag)
        @messenger.call(
          I18n.t(
            'presenters.register_price_tag.ok',
            display_name: price_tag.display_name,
            price_table: price_table(price_tag)
          )
        )
      end

      def argument_invalid
        @messenger.call(
          I18n.t('presenters.register_price_tag.argument_invalid')
        )
      end

      def update_failed
        @messenger.call(I18n.t('presenters.register_price_tag.update_failed'))
      end

      private

      def price_table(price_tag)
        price_tag.price_table(
          price_value: I18n.t('presenters.common.price_value'),
          registered_at: I18n.t('presenters.common.registered_at')
        )
      end
    end
  end
end
