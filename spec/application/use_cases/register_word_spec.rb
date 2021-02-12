# frozen_string_literal: true

require_relative '../../../src/application/use_cases/register_word'

describe UwoDictionaryBot::Application::UseCases::RegisterWord do
  subject(:use_case) do
    described_class.new(repository, factory, presenter: presenter)
  end

  let(:factory) { spy }
  let(:repository) { spy }
  let(:presenter) { spy }

  describe '#call' do
    shared_examples 'a successful case' do
      before do
        allow(factory).to receive(:create_new_word).and_return(anything)
        allow(repository).to receive(:register).and_return(true)
        allow(presenter).to receive(:ok)
      end

      it 'asks the factory to create a word' do
        use_case.call(*arguments)
        expect(factory).to have_received(:create_new_word)
      end

      it 'asks the repository to register the word' do
        use_case.call(*arguments)
        expect(repository).to have_received(:register)
      end

      it 'passes the word created to the presenter' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:ok)
      end
    end

    shared_examples 'a failed case with invalid arguments' do
      before do
        allow(presenter).to receive(:argument_invalid)
      end

      it 'does not ask the factory to create a word' do
        use_case.call(*arguments)
        expect(factory).not_to have_received(:create_new_word)
      end

      it 'does not ask the repository to register the word' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:register)
      end

      it 'triggers presenter#argument_invalid' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:argument_invalid)
      end
    end

    context 'when all arguments are given' do
      let(:arguments) { %w[name type description] }

      it_behaves_like 'a successful case'
    end

    context 'when name is nil' do
      let(:arguments) { [nil, 'type', 'description'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when name is blank' do
      let(:arguments) { [' ', 'type', 'description'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when type is nil' do
      let(:arguments) { ['name', nil, 'description'] }

      it_behaves_like 'a successful case'
    end

    context 'when type is blank' do
      let(:arguments) { ['name', ' ', 'description'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when description is nil' do
      let(:arguments) { ['name', 'type', nil] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when description is blank' do
      let(:arguments) { ['name', 'type', ' '] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when repository fails to update' do
      before do
        allow(factory).to receive(:create_new_word).and_return(anything)
        allow(repository).to receive(:register).and_return(false)
        allow(presenter).to receive(:update_failed)
      end

      let(:arguments) { %w[name type description] }

      it 'asks the factory to create a word' do
        use_case.call(*arguments)
        expect(factory).to have_received(:create_new_word)
      end

      it 'asks the repository to register the word' do
        use_case.call(*arguments)
        expect(repository).to have_received(:register)
      end

      it 'triggers presenter#update_failed' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:update_failed)
      end
    end
  end
end
