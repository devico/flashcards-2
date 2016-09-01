class Home::HomeController < Home::BaseController
  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      if current_user.current_block
        current_block_cards = current_user.current_block.cards

        @card = current_block_cards.pending.first
        @card ||= current_block_cards.repeating.first
      else
        user_cards = current_user_cards

        @card = user_cards.pending.first
        @card ||= user_cards.repeating.first
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
