import { Application } from "@hotwired/stimulus"

// Create and start the Stimulus application
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
application.handleError = (error, message, detail) => {
  console.warn(message, detail)
  console.error(error)
}

// Make it available globally
window.Stimulus = application

export { application }
