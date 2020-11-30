require 'rails_helper'

RSpec.describe AttachedFilePresenceValidator, type: :validator do
  describe 'has_one_attached' do
    let(:obj) { clazz.new }
    let(:clazz) do
      c = Class.new(ActiveRecord::Base) do
        self.table_name = :posts

        has_one_attached :main_image

        validates :main_image, attached_file_presence: true
      end
      stub_const('TestClass', c)
    end

    context 'without main_image' do
      let(:is_attached) { false }

      it { expect(obj).to be_invalid }
    end

    context 'with main_image' do
      let(:is_attached) { true }

      before { obj.main_image.attach(io: File.open(Rails.root.join('spec/fixtures/file_presence/file.dat')), filename: 'file.dat') }

      it { expect(obj).to be_valid }
    end
  end

  describe 'has_many_attached' do
    let(:obj) { clazz.new }
    let(:clazz) do
      c = Class.new(ActiveRecord::Base) do
        self.table_name = :posts
      end
      stub_const('TestClass', c)

      TestClass.has_many_attached :main_images
      TestClass.validates :main_images, attached_file_presence: true
      TestClass
    end

    context 'without main_image' do
      let(:is_attached) { false }

      it { expect(obj).to be_invalid }
    end

    context 'with main_images' do
      let(:is_attached) { true }

      before { obj.main_images.attach(io: File.open(Rails.root.join('spec/fixtures/file_presence/file.dat')), filename: 'file.dat') }

      it { expect(obj).to be_valid }
    end
  end
end
