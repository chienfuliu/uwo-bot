# frozen_string_literal: true

RSpec.describe UwoBotCore::Application::UseCases::RegisterPriceTag do
  subject(:use_case) do
    described_class.new(repository, factory, presenter: presenter)
  end

  let(:factory) { spy }
  let(:repository) { spy }
  let(:presenter) { spy }
  let(:price_tag) { spy }

  describe '#call' do
    shared_examples 'a successful case' do
      before do
        allow(factory).to receive(:create).and_return(price_tag)
        allow(repository).to receive(:find).and_return(price_tag)
        allow(repository).to receive(:register).and_return(true)
      end

      it 'asks the repository to find existing price_tag' do
        use_case.call(*arguments)
        normalized_name = arguments&.dig(0)&.to_s&.downcase&.strip
        normalized_type = arguments&.dig(1)&.to_s&.downcase&.strip
        expected_args = hash_including(
          name: normalized_name,
          type: normalized_type
        )
        expect(repository).to have_received(:find).with(expected_args)
      end

      context 'when no existing price_tag found' do
        before do
          allow(repository).to receive(:find).and_return(nil)
        end

        it 'asks the factory to create a price_tag' do
          use_case.call(*arguments)
          normalized_name = arguments&.dig(0)&.to_s&.downcase&.strip
          normalized_type = arguments&.dig(1)&.to_s&.downcase&.strip
          expected_args = [normalized_name, normalized_type]
          expect(factory).to have_received(:create).with(*expected_args)
        end
      end

      it 'triggers price_tag#update_price' do
        use_case.call(*arguments)
        expected_args = arguments&.dig(2)
        expect(price_tag).to have_received(:update_price).with(expected_args)
      end

      it 'asks the repository to register the price_tag' do
        use_case.call(*arguments)
        expect(repository).to have_received(:register)
      end

      it 'passes the price_tag created to the presenter' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:ok)
      end
    end

    shared_examples 'a failed case with invalid arguments' do
      it 'does not ask the factory to create a price_tag' do
        use_case.call(*arguments)
        expect(factory).not_to have_received(:create)
      end

      it 'does not ask the repository to register the price_tag' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:register)
      end

      it 'triggers presenter#argument_invalid' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:argument_invalid)
      end
    end

    context 'when all arguments are given' do
      let(:arguments) { %w[name type private] }

      it_behaves_like 'a successful case'
    end

    context 'when name is not in lower-case' do
      let(:arguments) { %w[NaMe type price_value] }

      it_behaves_like 'a successful case'
    end

    context 'when name is nil' do
      let(:arguments) { [nil, 'type', 'price_value'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when name is blank' do
      let(:arguments) { [' ', 'type', 'price_value'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when type is not in lower-case' do
      let(:arguments) { %w[name TyPe price_value] }

      it_behaves_like 'a successful case'
    end

    context 'when type is nil' do
      let(:arguments) { ['name', nil, 'price_value'] }

      it_behaves_like 'a successful case'
    end

    context 'when type is blank' do
      let(:arguments) { ['name', ' ', 'price_value'] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when price_value is nil' do
      let(:arguments) { ['name', 'type', nil] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when price_value is blank' do
      let(:arguments) { ['name', 'type', ' '] }

      it_behaves_like 'a failed case with invalid arguments'
    end

    context 'when price_tag fails to update price' do
      before do
        allow(repository).to receive(:find).and_return(price_tag)
        allow(price_tag).to receive(:update_price).and_raise
      end

      let(:arguments) { %w[name type price_value] }

      it 'does not ask the repository to register the price_tag' do
        use_case.call(*arguments)
        expect(repository).not_to have_received(:register)
      end

      it 'triggers presenter#update_failed' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:update_failed)
      end
    end

    context 'when repository fails to update' do
      before do
        allow(repository).to receive(:find).and_return(price_tag)
        allow(repository).to receive(:register).and_return(false)
      end

      let(:arguments) { %w[name type price_value] }

      it 'triggers presenter#update_failed' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:update_failed)
      end
    end
  end
end
