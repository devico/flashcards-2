every :day, at: '11:00 am' do
  runner 'CardNotificationService.notify_pending_cards'
end
