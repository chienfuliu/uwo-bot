# frozen_string_literal: true

require_relative '../../../src/application/use_cases/query_words'

describe UwoDictionaryBot::Application::UseCases::QueryWords do
  subject(:use_case) do
    described_class.new(repository, presenter: presenter)
  end

  let(:repository) { spy }
  let(:presenter) { spy }

  describe '#call' do
    shared_examples 'a successful case' do
      before do
        allow(repository).to receive(:query).and_return([word])
        allow(presenter).to receive(:ok)
      end

      let(:word) { spy(name: 'name', type: 'type', description: 'description') }

      it 'asks the repository to query words' do
        use_case.call(*arguments)
        expect(repository).to have_received(:query)
      end

      it 'passes the words found to the presenter' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:ok)
      end
    end

    shared_examples 'a failed case with invalid arguments' do
      before do
        allow(presenter).to receive(:argument_invalid)
      end

      it 'does not ask the repository to query words' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:query)
      end

      it 'triggers presenter#argument_invalid' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:argument_invalid)
      end
    end

    context 'when all arguments are given' do
      let(:arguments) { %w[name type] }

      it_behaves_like 'a successful case'
    end

    context 'when name is nil' do
      let(:arguments) { [nil, 'type'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when name is blank' do
      let(:arguments) { [' ', 'type'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when type is nil' do
      let(:arguments) { ['name', nil] }

      it_behaves_like 'a successful case'
    end

    context 'when type is blank' do
      let(:arguments) { ['name', ' '] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when words are not found' do
      before do
        allow(repository).to receive(:query).and_return([])
        allow(presenter).to receive(:word_not_found)
      end

      let(:arguments) { %w[name type] }

      it 'asks the repository to query words' do
        use_case.call(*arguments)
        expect(repository).to have_received(:query)
      end

      it 'triggers presenter#word_not_found' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:word_not_found)
      end
    end
  end
end
