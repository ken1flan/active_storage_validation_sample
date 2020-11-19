require 'rails_helper'

RSpec.describe AttachedFileNumberValidator, type: :validator do
  subject { clazz.new(attached_file) }

  let(:clazz) do
    tmp_options = options # クラス定義内でletを直接参照できないため

    c = Class.new do
      include ActiveModel::Model

      attr_reader :attached_file

      validates :attached_file, attached_file_number: tmp_options

      def initialize(attached_file)
        @attached_file = attached_file
      end
    end
    stub_const('AttachedFileSizeValidatorTestClass', c)
  end

  let(:attached_file) do
    attached_file = instance_double('attached_file mock')
    allow(attached_file).to receive(:size).and_return(file_number)
    allow(attached_file).to receive(:attached?).and_return(is_attached)
    attached_file
  end
  let(:is_attached) { true }
  let(:file_number) { 5 }

  context 'without options and attached_file' do
    let(:options) { true }
    let(:is_attached) { false }

    it { is_expected.to be_valid }
  end

  context 'without options, with file_number = 0' do
    let(:options) { true }
    let(:file_number) { 0 }

    it { is_expected.to be_valid }
  end

  context 'without options, with file_number = 1' do
    let(:options) { true }
    let(:file_number) { 1 }

    it { is_expected.to be_valid }
  end

  context 'with options = { maximum: 3 } and file_number = 3' do
    let(:options) { { maximum: 3 } }
    let(:file_number) { 3 }

    it { is_expected.to be_valid }
  end

  context 'with options = { maximum: 3 } and file_number = 4' do
    let(:options) { { maximum: 3 } }
    let(:file_number) { 4 }

    it { is_expected.to be_invalid }
  end

  context 'with options = { minimum: 3 } and file_number = 3' do
    let(:options) { { minimum: 3 } }
    let(:file_number) { 3 }

    it { is_expected.to be_valid }
  end

  context 'with options = { minimum: 3 } and file_number = 2' do
    let(:options) { { minimum: 3 } }
    let(:file_number) { 2 }

    it { is_expected.to be_invalid }
  end

  context 'with options = { minimum: 3, maximum: 5 } and file_number = 2' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 2 }

    it { is_expected.to be_invalid }
  end

  context 'with options = { minimum: 3, maximum: 5 } and file_number = 3' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 3 }

    it { is_expected.to be_valid }
  end

  context 'with options = { minimum: 3, maximum: 5 } and file_number = 5' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 5 }

    it { is_expected.to be_valid }
  end

  context 'with options = { minimum: 3, maximum: 5 } and file_number = 6' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 6 }

    it { is_expected.to be_invalid }
  end
end