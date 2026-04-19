import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values  = { open: Boolean }

  connect() {
    this.boundClose = () => (this.openValue = false)
    document.addEventListener("turbo:before-render", this.boundClose)
  }

  disconnect() {
    document.removeEventListener("turbo:before-render", this.boundClose)
  }

  toggle() {
    this.openValue = !this.openValue
  }

  openValueChanged() {
    if (this.hasButtonTarget) {
      this.buttonTarget.setAttribute("aria-expanded", this.openValue ? "true" : "false")
    }
  }
}
