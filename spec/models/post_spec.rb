require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(64) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(4096) }
    it { is_expected.to validate_attached_file_presence_of(:main_image) }
    it { is_expected.to validate_attached_file_presence_of(:other_images) }
    it { is_expected.to validate_attached_file_number_of(:other_images) }
  end
end
