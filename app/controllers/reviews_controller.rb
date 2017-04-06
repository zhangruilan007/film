class ReviewsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :find_film_and_check_favorite, only: [:new, :create]

  def new
    @film = Film.find(params[:film_id])
    @review = Review.new
  end

  def create
    @film = Film.find(params[:film_id])
    @review = Review.new(review_params)
    @review.film = @film
    @review.user = current_user

    if @review.save
      redirect_to film_path(@film)
    else
      render :new
    end
  end

def find_film_and_check_favorite
  @film = Film.find(params[:film_id])
  if !current_user.is_member_of?(@film)
    redirect_to film_path(@film), alert:"You have no permission!"
  end
end


  private

  def review_params
    params.require(:review).permit(:content)
  end

end
