class RandomCardService
  attr_accessor :user, :card_id

  def initialize(user, card_id)
    @user = user
    @card_id = card_id
  end

  def fetch_random_card
    current_cards = user.current_block.try(:cards) || user.cards
    current_cards.first_pending || current_cards.first_repeating
  end

  def call
    if card_id
      user.cards.find(card_id)
    else
      fetch_random_card
    end
  end
end
