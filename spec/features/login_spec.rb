require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'password authentication' do
  describe 'register' do
    before do
      visit root_path
    end

    it 'register TRUE' do
      register('test@test.com', '12345', '12345', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t(:user_created_successfully_notice)
    end

    it 'password confirmation FALSE' do
      register('test@test.com', '12345', '56789', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t('activerecord.errors.messages.confirmation')
    end

    it 'e-mail FALSE' do
      register('test', '12345', '12345', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t('activerecord.errors.messages.invalid')
    end

    it 'e-mail has already been taken' do
      register('test@test.com', '12345', '12345', I18n.t(:sign_up_label))
      click_link I18n.t(:log_out_label)
      register('test@test.com', '12345', '12345', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t('activerecord.errors.messages.taken')
    end

    it 'password is too short' do
      register('test@test.com', '1', '12345', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t('activerecord.errors.messages.too_short')
    end

    it 'password_confirmation is too short' do
      register('test@test.com', '12345', '1', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t('activerecord.errors.messages.confirmation')
    end
  end

  describe 'authentication' do
    before do
      create(:user)
      visit root_path
    end

    it 'require_login root' do
      expect(page).to have_content I18n.t(:welcome)
    end

    it 'authentication TRUE' do
      login('test@test.com', '12345', I18n.t(:log_in_label))
      expect(page).to have_content I18n.t(:log_in_is_successful_notice)
    end

    it 'incorrect e-mail' do
      login('1@1.com', '12345', I18n.t(:log_in_label))
      expect(page).
          to have_content I18n.t(:not_logged_in_alert)
    end

    it 'incorrect password' do
      login('test@test.com', '56789', I18n.t(:log_in_label))
      expect(page).
          to have_content I18n.t(:not_logged_in_alert)
    end

    it 'incorrect e-mail and password' do
      login('1@1.com', '56789', I18n.t(:log_in_label))
      expect(page).
          to have_content I18n.t(:not_logged_in_alert)
    end
  end

  describe 'change language' do
    before do
      visit root_path
    end

    it 'home page' do
      click_link 'en'
      expect(page).to have_content I18n.t(:welcome)
    end

    it 'register TRUE' do
      click_link 'en'
      register('test@test.com', '12345', '12345', I18n.t(:sign_up_label))
      expect(page).to have_content I18n.t(:user_created_successfully_notice)
    end

    it 'default locale' do
      click_link 'en'
      register('test@test.com', '12345', '12345', I18n.t(:sign_up_label))
      user = User.find_by_email('test@test.com')
      expect(user.locale).to eq('en')
    end

    it 'available locale' do
      click_link 'en'
      register('test@test.com', '12345', '12345', I18n.t(:sign_up_label))
      click_link I18n.t(:user_profile_label)
      fill_in 'user[password]', with: '12345'
      fill_in 'user[password_confirmation]', with: '12345'
      click_button I18n.t(:save)
      expect(page).to have_content I18n.t(:user_profile_success_notice)
    end

    it 'authentication TRUE' do
      click_link 'en'
      create(:user)
      login('test@test.com', '12345', I18n.t(:log_in_label))
      expect(page).to have_content I18n.t(:log_in_is_successful_notice)
    end
  end
end
