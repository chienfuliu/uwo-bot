# frozen_string_literal: true

RSpec.describe UwoBotCore::Application::UseCases::QueryPriceTags do
  subject(:use_case) do
    described_class.new(repository, presenter: presenter)
  end

  let(:repository) { spy }
  let(:presenter) { spy }

  describe '#call' do
    shared_examples 'a successful case' do
      before do
        allow(repository).to receive(:query).and_return([price_tag])
      end

      let(:price_tag) { spy(name: 'name', type: 'type', prices: [price]) }
      let(:price) { spy(value: 'price_value', registered_at: Time.now.utc) }

      it 'asks the repository to query price_tags' do
        use_case.call(*arguments)
        normalized_name = arguments&.dig(0)&.to_s&.downcase&.strip
        expected_args = hash_including(name: normalized_name)
        expect(repository).to have_received(:query).with(expected_args)
      end

      it 'passes the price_tags found to the presenter' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:ok)
      end
    end

    shared_examples 'a failed case with invalid arguments' do
      it 'does not ask the repository to query price_tags' do
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

    context 'when price_tags are not found' do
      before do
        allow(repository).to receive(:query).and_return([])
      end

      let(:arguments) { %w[name type] }

      it 'triggers presenter#not_found' do
        use_case.call(*arguments)
        expect(presenter).to have_received(:not_found)
      end
    end
  end
end
