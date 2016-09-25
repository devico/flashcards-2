require 'rails_helper'

RSpec.describe RolePolicy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }

  describe 'rails_admin?' do
    rails_admin_permissions do
      it 'allows only admin' do
        expect(subject).to permit(admin, nil, :index)
      end

      it 'forbids other users' do
        expect(subject).not_to permit(moderator, nil, :index)
      end
    end
  end
end
