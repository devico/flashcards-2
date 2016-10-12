require 'rails_helper'

RSpec.describe CardPolicy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }

  describe 'rails_admin?' do
    rails_admin_permissions do
     it 'allows admin to destroy' do
       expect(subject).to permit(admin, nil, :destroy)
     end

     it 'forbids moderator to destoy' do
       expect(subject).not_to permit(moderator, nil, :destroy)
     end

     it 'allows admin and moderator to do all other actions'do
      expect(subject).to permit(moderator, nil, :index)
     end
    end
  end
end
