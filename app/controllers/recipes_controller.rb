class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    if params[:meal_type]
      @recipes = Recipe.where(meal_type: params[:meal_type]).order(:name)
    elsif params[:protein]
      @recipes = Recipe.where(protein: params[:protein]).order(:name)
    else 
      @recipes = Recipe.all.order(:name)
    end
    ids = Quote.pluck(:id)
    unless ids.empty?
      @quote = Quote.find(ids.sample)
    end
    @new_recipes = Recipe.last(5)
  end

  def show
    @recipe = Recipe.find(params[:id])
    if user_signed_in?
      @new_comment = current_user.comments.build
    end
  end

  def new
    @recipe = Recipe.new
    @recipe.ingredients.build
    @recipe.steps.build
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      render :new, status: :unprocessable_entity
    end
  end 

  def edit
    @recipe = Recipe.find(params[:id])
    if @recipe.ingredients.empty?
      @recipe.ingredients.build
    end
    if @recipe.steps.empty?
      @recipe.steps.build
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.ingredients.destroy_all
    @recipe.steps.destroy_all
    unless @recipe.user_id
      @recipe.user_id = current_user.id
    end

    add_pictures
    
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      flash[:error] = @recipe.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def all
    if params[:query]
      @recipes = Recipe.where("name ~* ?", "#{params[:query]}").order(:name)
      unless params[:query] == ""
        @ingredients = Ingredient.where("name ~* ?", "#{params[:query]}").order(:name)
      end
      elsif params[:meal_type]
      @recipes = Recipe.where(meal_type: params[:meal_type]).order(:name)
    elsif params[:protein]
      @recipes = Recipe.where(protein: params[:protein]).order(:name)
    else
      @recipes = Recipe.all.order(:name)
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:user_id, :name, :meal_type, :culture, :protein, :servings, :author, :recipe_card, :image, ingredients_attributes: [:name, :measurement_amount, :measurement_type], steps_attributes: [:instructions])
  end

  def add_pictures
    if params[:recipe][:recipe_card]
      @recipe.recipe_card.attach(params[:recipe][:recipe_card])
    end
    if params[:recipe][:image]
      @recipe.image.attach(params[:recipe][:image])
    end
  end

end
