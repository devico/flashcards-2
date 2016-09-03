class Home::HomeController < Home::BaseController
  def index
    @card = RandomCardService.new(current_user, params[:id]).call

    respond_to do |format|
      format.html
      format.js
    end
  end
end
