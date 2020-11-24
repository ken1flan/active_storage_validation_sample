require 'rails_helper'

RSpec.describe AttachedFileSizeValidator, type: :validator do
  describe 'has_one_attached' do
    let(:clazz) do
      tmp_options = options # クラス定義内でletを直接参照できないため

      c = Class.new(ActiveRecord::Base) do
        self.table_name = :posts

        has_one_attached :main_image

        validates :main_image, attached_file_size: tmp_options
      end
      stub_const('TestClass', c)
    end

    let(:obj) { clazz.new }

    context 'with options = { maximum: 1.kilobyte }, without file' do
      let(:options) { { maximum: 1.kilobyte } }

      it { expect(obj.valid?).to be_truthy }
    end

    context 'with options = { maximum: 1KB } and attached_file whose size is 1024 Bytes' do
      let(:options) { { maximum: 1.kilobyte } }

      before { obj.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/file_size/1024Byte.dat')), filename: 'file.dat') }

      it { expect(obj).to be_valid }
    end

    context 'with options = { maximum: 1KB } and attached_file whose size is 1025 Bytes' do
      let(:options) { { maximum: 1.kilobyte } }

      before { obj.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/file_size/1025Byte.dat')), filename: 'file.dat') }

      it { expect(obj).to be_invalid }
    end
  end

  describe 'has_many_attached' do
    let(:clazz) do
      tmp_options = options # クラス定義内でletを直接参照できないため

      c = Class.new(ActiveRecord::Base) do
        self.table_name = :posts
      end
      stub_const('TestClass', c)

      TestClass.has_many_attached :main_images # Class.newのブロックの中だとクラス名がなくてundefined method `demodulize' for nil:NilClassになるので…。
      TestClass.validates :main_images, attached_file_size: tmp_options
      TestClass
    end

    let(:obj) { clazz.new }

    context 'with options = { maximum: 1.kilobyte }, without file' do
      let(:options) { { maximum: 1.kilobyte } }

      it { expect(obj.valid?).to be_truthy }
    end

    context 'with options = { maximum: 1KB } and attached_file whose size is 1024 Bytes' do
      let(:options) { { maximum: 1.kilobyte } }

      before { obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_size/1024Byte.dat')), filename: 'file.dat') }

      it { expect(obj).to be_valid }
    end

    context 'with options = { maximum: 1KB } and attached_file whose size is 1025 Bytes' do
      let(:options) { { maximum: 1.kilobyte } }

      before { obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_size/1025Byte.dat')), filename: 'file.dat') }

      it { expect(obj).to be_invalid }
    end

    context 'with options = { maximum: 1KB } and attached_files whose sizes are 1024 and 1025 Bytes' do
      let(:options) { { maximum: 1.kilobyte } }

      before do
        obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_size/1024Byte.dat')), filename: 'file.dat')
        obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_size/1025Byte.dat')), filename: 'file.dat')
      end

      it { expect(obj).to be_invalid }
    end
  end
end
