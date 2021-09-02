# frozen_string_literal: true

require_relative '../../../src/application/use_cases/deregister_word'

describe UwoDictionaryBot::Application::UseCases::DeregisterWord do
  subject(:use_case) do
    described_class.new(repository, presenter: presenter)
  end

  let(:repository) { spy }
  let(:presenter) { spy }

  describe '#call' do
    shared_examples 'a successful case' do
      before do
        allow(repository).to receive(:find).and_return(anything)
        allow(repository).to receive(:deregister).and_return(true)
        allow(presenter).to receive(:ok)
      end

      it 'asks the repository to find the word' do
        use_case.call(*arguments)
        normalized_name = arguments&.dig(0)&.to_s&.downcase&.strip
        normalized_type = arguments&.dig(1)&.to_s&.downcase&.strip
        expected_args = hash_including(
          name: normalized_name,
          type: normalized_type
        )
        expect(repository).to have_received(:find).with(expected_args)
      end

      it 'asks the repository to deregister the word' do
        use_case.call(*arguments)
        expect(repository).to have_received(:deregister)
      end

      it 'passes the word removed to the presenter' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:ok)
      end
    end

    shared_examples 'a failed case with invalid arguments' do
      before do
        allow(presenter).to receive(:argument_invalid)
      end

      it 'does not ask the repository to find the word' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:find)
      end

      it 'does not ask the repository to deregister the word' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:deregister)
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

    context 'when name is not in lower-case' do
      let(:arguments) { %w[NaMe type] }

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

    context 'when type is not in lower-case' do
      let(:arguments) { %w[name TyPe] }

      it_behaves_like 'a successful case'
    end

    context 'when type is nil' do
      let(:arguments) { ['name', nil] }

      it_behaves_like 'a successful case'
    end

    context 'when type is blank' do
      let(:arguments) { ['name', ' '] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when word is not found' do
      before do
        allow(repository).to receive(:find).and_return(nil)
        allow(presenter).to receive(:word_not_found)
      end

      let(:arguments) { %w[name type] }

      it 'asks the repository to find the word' do
        use_case.call(*arguments)
        expect(repository).to have_received(:find)
      end

      it 'does not ask the repository to deregister the word' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:deregister)
      end

      it 'triggers presenter#word_not_found' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:word_not_found)
      end
    end

    context 'when repository fails to update' do
      before do
        allow(repository).to receive(:deregister).and_return(false)
        allow(presenter).to receive(:update_failed)
      end

      let(:arguments) { %w[name type] }

      it 'asks the repository to find the word' do
        use_case.call(*arguments)
        expect(repository).to have_received(:find)
      end

      it 'asks the repository to deregister the word' do
        use_case.call(*arguments)
        expect(repository).to have_received(:deregister)
      end

      it 'triggers presenter#update_failed' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:update_failed)
      end
    end
  end
end
