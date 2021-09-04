# frozen_string_literal: true

module UwoBotService
  module Controllers
    class WordsController
      def initialize(**configurations)
        @word_repository = configurations[:word_repository]
        @word_factory = configurations[:word_factory]
        @messenger = configurations[:messenger]
      end

      def ask(_event, name, *)
        presenter = Presenters::QueryWordsPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::QueryWords.new(
          @word_repository,
          presenter: presenter
        )

        type, name = name.split('_', 2) if name.match?(/\w+_\w+/)
        use_case.call(name, type)
      end

      def learn(event, name, *)
        presenter = Presenters::RegisterWordPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::RegisterWord.new(
          @word_repository,
          @word_factory,
          presenter: presenter
        )

        type, name = name.split('_', 2) if name.match?(/\w+_\w+/)
        # Retrieve description from the rest of content as it may contain
        # space or new line characters, and we would like to keep the format.
        description = event.content.split(' ', 3).last.strip
        use_case.call(name, type, description)
      end

      def forget(_event, name, *)
        presenter = Presenters::DeregisterWordPresenter.new(@messenger)
        use_case = UwoBotCore::Application::UseCases::DeregisterWord.new(
          @word_repository,
          presenter: presenter
        )

        type, name = name.split('_', 2) if name.match?(/\w+_\w+/)
        use_case.call(name, type)
      end
    end
  end
end
