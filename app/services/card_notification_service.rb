class CardNotificationService
  def users_with_email
    User.with_email
  end

  def self.notify_pending_cards
    users_with_email.each do |user|
      if user.cards.pending.any?
        send_mail!
      end
    end
  end

  def send_mail!
    CardsMailer.pending_cards_notification(user.email).deliver
  end
end
