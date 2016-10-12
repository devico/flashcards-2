require 'rails_helper'

RSpec.describe BlockPolicy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:member) { create(:user, :member) }
  let(:moderator) { create(:user, :moderator) }

  describe 'rails_admin?' do
    rails_admin_permissions do
      it 'allows admin to destroy' do
        expect(subject).to permit(admin, nil, :destroy)
      end

      it 'forbids members to view admin panel' do
        expect(subject).not_to permit(member, nil, :dashboard)
      end

      it 'forbids moderator to destroy' do
        expect(subject).not_to permit(moderator, nil, :destroy)
      end
    end
  end
end
