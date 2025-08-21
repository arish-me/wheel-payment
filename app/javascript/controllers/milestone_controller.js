import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "toggle"]

  connect() {
    console.log("Milestone controller connected")
  }

  toggleForm() {
    this.formTarget.classList.toggle("hidden")
  }

  confirmAction(event) {
    const action = event.currentTarget.dataset.action
    const milestoneTitle = event.currentTarget.dataset.milestoneTitle
    
    if (!confirm(`Are you sure you want to ${action} the milestone "${milestoneTitle}"?`)) {
      event.preventDefault()
    }
  }

  // Handle milestone form submission
  submitForm(event) {
    const form = event.target
    const submitButton = form.querySelector('input[type="submit"]')
    
    if (submitButton) {
      submitButton.disabled = true
      submitButton.value = "Creating..."
    }
  }
}
