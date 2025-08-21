import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output", "button"]
  static values = { count: Number }

  connect() {
    this.countValue = 0
    this.updateOutput()
  }

  increment() {
    this.countValue++
    this.updateOutput()
  }

  updateOutput() {
    this.outputTarget.textContent = `You clicked ${this.countValue} times!`
  }

  // Example method for handling milestone actions
  handleMilestoneAction(event) {
    const action = event.currentTarget.dataset.action
    const milestoneId = event.currentTarget.dataset.milestoneId
    
    if (confirm(`Are you sure you want to ${action} this milestone?`)) {
      // This would typically make an AJAX request
      console.log(`Performing ${action} on milestone ${milestoneId}`)
    }
  }
}
