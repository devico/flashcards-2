class Home::HomeController < Home::BaseController
  def index
    @card =
      if id = params[:id]
        current_user.cards.find(id)
      else
        current_user.generate_random_card
      end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
