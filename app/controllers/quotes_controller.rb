class QuotesController < ApplicationController
  before_action :authenticate_user!

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.new(quote_params)
    if @quote.save
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @quote = Quote.find(params[:id])
  end

  def update
    @quote = Quote.find(params[:id])
    if @quote.update(quote_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def quote_params
    params.require(:quote).permit(:body, :user_id)
  end
end
