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
    if params[:chosen_recipe]
      @chosen_recipe = Recipe.find(params[:chosen_recipe])
    else
      ids = Recipe.pluck(:id)
      @chosen_recipe = Recipe.find(ids.sample)
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = current_user.comments.build
  end

  def new
    @recipe = current_user.recipes.build
    @recipe.ingredients.build
    @recipe.steps.build
  end

  def create
    @recipe = Recipe.new(recipe_params)
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
      @ingredients = Ingredient.where("name ~* ?", "#{params[:query]}").order(:name)
    elsif params[:meal_type]
      @recipes = Recipe.where(meal_type: params[:meal_type]).order(:name)
      @ingredients = nil
    elsif params[:protein]
      @recipes = Recipe.where(protein: params[:protein]).order(:name)
      @ingredients = nil
    else
      @recipes = Recipe.all.order(:name)
      @ingredients = nil
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:user_id, :name, :meal_type, :culture, :protein, :servings, :author, ingredients_attributes: [:name, :measurement_amount, :measurement_type], steps_attributes: [:instructions])
  end

end
