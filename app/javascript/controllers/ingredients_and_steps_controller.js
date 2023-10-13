import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ingredients-and-steps"
export default class extends Controller {
  static targets = ["ingredientList", "ingredient", "ingredientTemplate", "stepList", "step", "stepTemplate", "warning"]
  static values = { ingredients: Number, steps: Number }
  
  connect() {
    }

  addIngredient() {
    const clone = this.ingredientTemplateTarget.content.cloneNode(true)
    clone.querySelector("div>:nth-child(2)").setAttribute("name",`recipe[ingredients_attributes][${this.ingredientsValue}][name]`)
    clone.querySelector("div>:nth-child(4)").setAttribute("name",`recipe[ingredients_attributes][${this.ingredientsValue}][measurement_amount]`)
    clone.querySelector("div>:nth-child(6)").setAttribute("name",`recipe[ingredients_attributes][${this.ingredientsValue}][measurement_type]`)
    this.ingredientListTarget.appendChild(clone)
    this.ingredientsValue++
  }

  removeIngredient() {
    if (this.ingredientsValue > 1) {
    this.warningTarget.textContent = ""
    this.ingredientListTarget.removeChild(this.ingredientListTarget.lastElementChild)
    this.ingredientsValue--
    }
    else {
      this.warningTarget.textContent = "You must have at least one ingredient, silly."
    }
  }

  addStep() {
    const clone = this.stepTemplateTarget.content.cloneNode(true)
    clone.querySelector("li>:nth-child(2)").setAttribute("name",`recipe[steps_attributes][${this.stepsValue}][instructions]`)
    this.stepListTarget.appendChild(clone)
    this.stepsValue++
  }

  removeStep() {
    if (this.stepsValue > 1) {
    this.warningTarget.textContent = ""
    this.stepListTarget.removeChild(this.stepListTarget.lastElementChild)
    this.stepsValue--
    }
    else {
      this.warningTarget.textContent = "You must have at least one step, silly."
    }
  }
  
}
