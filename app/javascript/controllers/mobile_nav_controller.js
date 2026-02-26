import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "hamburger", "closeIcon"]

  connect() {
    this._onNavigate = this.close.bind(this)
    document.addEventListener("turbo:load", this._onNavigate)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this._onNavigate)
  }

  toggle() {
    const open = !this.menuTarget.classList.contains("hidden")
    open ? this.close() : this.open()
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.hamburgerTarget.classList.add("hidden")
    this.closeIconTarget.classList.remove("hidden")
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.hamburgerTarget.classList.remove("hidden")
    this.closeIconTarget.classList.add("hidden")
  }
}
