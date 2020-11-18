require 'rails_helper'

RSpec.describe AttachedFilePresenceValidator, type: :validator do
  subject { clazz.new(attached_file) }

  let(:clazz) do
    c = Class.new do
      include ActiveModel::Model

      attr_reader :attached_file

      validates :attached_file, attached_file_presence: true

      def initialize(attached_file)
        @attached_file = attached_file
      end
    end
    stub_const('AttachedFilePresenceValidatorTestClass', c)
  end

  let(:attached_file) do
    attached_file = instance_double('attached_file mock')
    allow(attached_file).to receive(:attached?).and_return(is_attached)
    attached_file
  end

  context 'when attached? return false' do
    let(:is_attached) { false }

    it { is_expected.to be_invalid }
  end

  context 'when attached? return true' do
    let(:is_attached) { true }

    it { is_expected.to be_valid }
  end
end
