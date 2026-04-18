import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values  = { url: String }

  connect() {
    this.timeout = null
    this.boundOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.boundOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.boundOutsideClick)
  }

  query(event) {
    const q = event.target.value.trim()
    clearTimeout(this.timeout)
    if (q.length < 2) {
      this.clearResults()
      return
    }
    this.timeout = setTimeout(() => this.fetch(q), 200)
  }

  async fetch(q) {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(q)}`, {
      headers: { "Accept": "text/html" }
    })
    if (!response.ok) return

    const html = await response.text()
    const doc = new DOMParser().parseFromString(html, "text/html")
    this.clearResults()
    Array.from(doc.body.childNodes).forEach(node => {
      this.resultsTarget.appendChild(node)
    })
  }

  clearResults() {
    this.resultsTarget.replaceChildren()
  }

  pick(event) {
    const email = event.currentTarget.dataset.email
    if (!email) return
    this.inputTarget.value = email
    this.clearResults()
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.clearResults()
    }
  }
}
