class RecipesController < ApplicationController
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
  end

  def new
    @recipe = Recipe.new
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
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.ingredients.destroy_all
    @recipe.steps.destroy_all
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def all
    @recipes = Recipe.where("name ~* ?", "#{params[:query]}")
    if params[:meal_type]
      @recipes = Recipe.where(meal_type: params[:meal_type]).order(:name)
    elsif params[:protein]
      @recipes = Recipe.where(protein: params[:protein]).order(:name)
    else 
      @recipes = Recipe.all.order(:name)
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :meal_type, :culture, :protein, :servings, :author, ingredients_attributes: [:name, :measurement_amount, :measurement_type], steps_attributes: [:instructions])
  end

end
