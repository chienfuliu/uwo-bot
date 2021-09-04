# frozen_string_literal: true

module UwoBotLambda
  module Controllers
    class WordsController < Base
      def initialize(**options)
        super
        @messenger = options[:messenger]
      end

      def ask(params)
        presenter = Presenters::QueryWordsPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::QueryWords.new(
          word_repository, presenter: presenter
        )

        name, type = params.values_at(*%w[name type])
        use_case.call(name, type)
      end

      def learn(params)
        presenter = Presenters::RegisterWordPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::RegisterWord.new(
          word_repository, word_factory, presenter: presenter
        )

        name, type, description = params.values_at(*%w[name type description])
        # Need to replace the literal \n with newline characters as arguments
        # sent from slash commands cannot have line breaks.
        description = description.gsub(/\\n/, "\n")
        use_case.call(name, type, description)
      end

      def forget(params)
        presenter = Presenters::DeregisterWordPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::DeregisterWord.new(
          word_repository, presenter: presenter
        )

        name, type = params.values_at(*%w[name type])
        use_case.call(name, type)
      end
    end
  end
end
