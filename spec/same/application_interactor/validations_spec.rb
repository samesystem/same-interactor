# frozen_string_literal: true

require 'spec_helper'

module Same
  module Interactor
    RSpec.describe Validations do
      subject(:interactor) do
        Class.new do
          include Interactor
          include Interactor::Validations

          context_attr :status

          validates :status, inclusion: { in: ['ok'] }

          def self.name
            'DummyInteractor'
          end

          def call
            context.message = 'successfully executed'
          end
        end
      end

      describe '.call' do
        subject(:call) { interactor.call(interactor_params) }

        let(:interactor_params) { { status: 'ok' } }

        context 'when all validations passes' do
          it { is_expected.to be_success }

          it 'executes #call part' do
            expect(call.message).to eq 'successfully executed'
          end
        end

        context 'when some validations fail' do
          let(:interactor_params) { { status: 'bad' } }

          it { is_expected.to be_failure }

          it 'does not execute #call part' do
            expect(call.message).to be_blank
          end

          it 'sets #errors' do
            expect(call.errors[:status]).to eq(['is not included in the list'])
          end
        end
      end
    end
  end
end
