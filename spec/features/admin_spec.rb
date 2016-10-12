require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'access to admin interface' do
  describe 'visit' do
    before do
      visit root_path
    end

    it 'as member' do
      user = create(:user, :member)

      login(user.email, '12345', I18n.t(:log_in_label))
      visit rails_admin_path

      expect(page).to have_content I18n.t(:no_permission)
    end

    it 'as moderator' do
      user = create(:user, :moderator)

      login(user.email, '12345', I18n.t(:log_in_label))
      visit rails_admin_path

      expect(page).to have_content I18n.t(:dashboard)
    end

   it 'as admin' do
      user = create(:user, :admin)

      login(user.email, '12345', I18n.t(:log_in_label))
      visit rails_admin_path

      expect(page).to have_content I18n.t(:dashboard)
    end
  end
end
