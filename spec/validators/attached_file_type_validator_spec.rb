require 'rails_helper'

RSpec.describe AttachedFileTypeValidator, type: :validator do
  describe 'has_one_attached' do
    let(:clazz) do
      tmp_options = options # クラス定義内でletを直接参照できないため

      c = Class.new(ActiveRecord::Base) do
        self.table_name = :posts

        has_one_attached :main_image

        validates :main_image, attached_file_type: tmp_options
      end
      stub_const('TestClass', c)
    end

    let(:obj) { clazz.new }

    context 'when options are null' do
      let(:options) { true }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ }' do
      let(:options) { { pattern: /^image\/.*/ } }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and png file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before { obj.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/yuzuyu.png')), filename: 'yuzuyu.png') }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and jpeg file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before { obj.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/ramen.jpg')), filename: 'ramen.jpg') }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and text file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before { obj.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/love_cats.txt')), filename: 'love_cats.txt') }

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

      TestClass.has_many_attached :main_images
      TestClass.validates :main_images, attached_file_type: tmp_options
      TestClass
    end

    let(:obj) { clazz.new }

    context 'when options are null' do
      let(:options) { true }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ }' do
      let(:options) { { pattern: /^image\/.*/ } }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and png file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before { obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/yuzuyu.png')), filename: 'yuzuyu.png') }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and jpeg file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before { obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/ramen.jpg')), filename: 'ramen.jpg') }

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and text file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before { obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/love_cats.txt')), filename: 'love_cats.txt') }

      it { expect(obj).to be_invalid }
    end

    context 'with options = { pattern: /^image\/.*/ } and png and jpeg file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before do
        obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/yuzuyu.png')), filename: 'yuzuyu.png')
        obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/ramen.jpg')), filename: 'ramen.jpg')
      end

      it { expect(obj).to be_valid }
    end

    context 'with options = { pattern: /^image\/.*/ } and png and text file attached' do
      let(:options) { { pattern: /^image\/.*/ } }

      before do
        obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/yuzuyu.png')), filename: 'yuzuyu.png')
        obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_type/love_cats.txt')), filename: 'love_cats.txt')
      end

      it { expect(obj).to be_invalid }
    end
  end
end
