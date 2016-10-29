class FillCardsJob < ApplicationJob
  queue_as :default

  def perform(current_user, options)
    ParseCardsService.new(current_user, options).call
  end
end
