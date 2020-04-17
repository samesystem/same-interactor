# frozen_string_literal: true

module Same
  RSpec.describe Interactor do
    subject(:application_interactor) { interactor_with_required_attributes }

    let(:interactor_with_required_attributes) do
      Class.new do
        include Interactor

        context_attr :amount

        def call
          context.is_called = true
          context.received_amount = amount
        end

        def self.name
          'DummyInteractor'
        end
      end
    end

    describe '#call' do
      subject(:call) { application_interactor.call(attributes) }

      let(:attributes) { { amount: 1337 } }

      context 'when attribute defined in context_attr is given' do
        it { is_expected.to be_success }

        it 'executes call part' do
          expect(call.is_called).to be true
        end
      end

      context 'when interactor has required context_attr' do
        context 'when attribute defined in context_attr is nil' do
          let(:attributes) { { amount: nil } }

          it { is_expected.to be_success }

          it 'executes call part' do
            expect(call.is_called).to be true
          end
        end

        context 'when attribute defined in context_attr is not given' do
          let(:attributes) { {} }

          it 'raises MissingAttributeError' do
            expect { call }.to raise_error(
              Interactor::MissingAttributeError,
              'Context attributes are missing. Missing attributes are: [:amount]'
            )
          end
        end
      end

      context 'when interactor has optional context_attr' do
        let(:application_interactor) do
          Class.new(interactor_with_required_attributes) do
            context_attr :amount, optional: true

            def self.name
              'DummyOptionalInteractor'
            end
          end
        end

        context 'when attribute defined in context_attr is nil' do
          let(:attributes) { { amount: nil } }

          it { is_expected.to be_success }

          it 'executes call part' do
            expect(call.is_called).to be true
          end
        end

        context 'when attribute defined in context_attr is not given' do
          let(:attributes) { {} }

          it 'executes call part' do
            expect(call.is_called).to be true
          end

          it 'sets correct value' do
            expect(call.received_amount).to be nil
          end
        end
      end

      context 'when interactor has context_attr with default value' do
        let(:default_value) { -1 }

        let(:application_interactor) do
          default = default_value
          Class.new(interactor_with_required_attributes) do
            context_attr :amount, default: default

            def self.name
              'DummyWithDefaultsInteractor'
            end
          end
        end

        context 'when attribute defined in context_attr is nil' do
          let(:attributes) { { amount: nil } }

          it { is_expected.to be_success }

          it 'executes call part' do
            expect(call.is_called).to be true
          end

          it 'sets nil value' do
            expect(call.received_amount).to be_nil
          end
        end

        context 'when attribute defined in context_attr is not given' do
          let(:attributes) { {} }

          it 'executes call part' do
            expect(call.is_called).to be true
          end

          it 'sets default value' do
            expect(call.received_amount).to eq default_value
          end

          context 'when default value is lambda' do
            let(:default_value) do
              -> { "default: #{self.class.name}" }
            end

            it 'executes call part' do
              expect(call.is_called).to be true
            end

            it 'executes given lambda in interactor context' do
              expect(call.received_amount).to eq 'default: DummyWithDefaultsInteractor'
            end
          end
        end
      end
    end
  end
end
