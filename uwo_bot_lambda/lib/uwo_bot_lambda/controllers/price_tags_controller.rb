# frozen_string_literal: true

module UwoBotLambda
  module Controllers
    class PriceTagsController < Base
      def initialize(**options)
        super
        @messenger = options[:messenger]
      end

      def ask(params)
        presenter = Presenters::QueryPriceTagsPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::QueryPriceTags.new(
          price_tag_repository, presenter: presenter
        )

        name, type = params.values_at(*%w[name type])
        use_case.call(name, type)
      end

      def learn(params)
        presenter = Presenters::RegisterPriceTagPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::RegisterPriceTag.new(
          price_tag_repository, price_tag_factory, presenter: presenter
        )

        name, type, price_value = params.values_at(*%w[name type price])
        use_case.call(name, type, price_value)
      end
    end
  end
end
