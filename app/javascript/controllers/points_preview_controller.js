import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["amount", "output"]
  static values  = { rate: Number }

  compute() {
    const amount = parseInt(this.amountTarget.value, 10)
    if (!Number.isFinite(amount) || amount <= 0 || !(this.rateValue > 0)) {
      this.outputTarget.textContent = "—"
      return
    }
    const points = Math.floor(amount / this.rateValue)
    this.outputTarget.textContent = points.toString()
  }
}
