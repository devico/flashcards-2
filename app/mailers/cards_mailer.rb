class CardsMailer < ActionMailer::Base
  default from: 'example@gmail.com'

  def pending_cards_notification(email)
    mail(to: email, subject: 'Наступила даты пересмотра карточек.')
  end

  def parsed_cards_notification(user_id, words, errors)
    @user = User.find(user_id)
    @words = words
    @errors = errors

    mail(to: @user.email, subject: 'Добавлены новые карточки!')
  end
end
