require 'rails_helper'

RSpec.describe AttachedFileNumberValidator, type: :validator do
  subject { clazz.new(attached_file) }

  let(:obj) { clazz.new }
  let(:clazz) do
    tmp_options = options # クラス定義内でletを直接参照できないため

    c = Class.new(ActiveRecord::Base) do
      self.table_name = :posts
    end
    stub_const('TestClass', c)

    TestClass.has_many_attached :main_images
    TestClass.validates :main_images, attached_file_number: tmp_options
    TestClass
  end

  before do
    file_number.times do |i|
      obj.main_images.attach(io: File.open(Rails.root.join("spec/fixtures/file_number/file#{i}.dat")), filename: "file#{i}.dat")
    end
  end

  context 'with options = true, file number = 0' do
    let(:options) { true }
    let(:file_number) { 0 }

    it { expect(obj).to be_valid }
  end

  context 'with options = true, file number = 1' do
    let(:options) { true }
    let(:file_number) { 0 }

    it { expect(obj).to be_valid }
  end

  context 'with options = { maximum: 2 }, file number = 2' do
    let(:options) { { maximum: 2 } }
    let(:file_number) { 2 }

    it { expect(obj).to be_valid }
  end

  context 'with options = { maximum: 2 }, file number = 3' do
    let(:options) { { maximum: 2 } }
    let(:file_number) { 3 }

    it { expect(obj).to be_invalid }
  end

  context 'with options = { minimum: 2 }, file number = 1' do
    let(:options) { { minimum: 2 } }
    let(:file_number) { 1 }

    it { expect(obj).to be_invalid }
  end

  context 'with options = { minimum: 2 }, file number = 2' do
    let(:options) { { minimum: 2 } }
    let(:file_number) { 2 }

    it { expect(obj).to be_valid }
  end

  context 'with options = { minimum: 3, maximum: 5 }, file number = 2' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 2 }

    it { expect(obj).to be_invalid }
  end

  context 'with options = { minimum: 3, maximum: 5 }, file number = 3' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 3 }

    it { expect(obj).to be_valid }
  end

  context 'with options = { minimum: 3, maximum: 5 } and file_number = 5' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 5 }

    it { expect(obj).to be_valid }
  end

  context 'with options = { minimum: 3, maximum: 5 } and file_number = 6' do
    let(:options) { { minimum: 3, maximum: 5 } }
    let(:file_number) { 6 }

    it { expect(obj).to be_invalid }
  end
end
