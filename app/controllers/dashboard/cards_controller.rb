class Dashboard::CardsController < Dashboard::BaseController
  before_action :set_card, only: [:destroy, :edit, :update]

  def index
    @cards = current_user.cards.order(:review_date)
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = current_user.cards.build(card_params)

    if @card.save
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def destroy
    @card.destroy
    respond_with @card
  end

  def load_cards_form

  end

  def parse_resourse
    FillCardsJob.perform_later(@current_user.id, card_form_params.to_h)

    redirect_to cards_path
  end

  private

  def card_form_params
    params.require(:card_form).permit(:translated_text_selector, :original_text_selector, :url, :search_xpath)
  end

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date,
                                 :image, :image_cache, :remove_image, :block_id, :remote_image_url)
  end
end
