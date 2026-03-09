import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this._onOutsideClick = this._onOutsideClick.bind(this)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    if (!this.menuTarget.classList.contains("hidden")) {
      document.addEventListener("click", this._onOutsideClick)
    }
  }

  _onOutsideClick(e) {
    if (!this.element.contains(e.target)) {
      this.menuTarget.classList.add("hidden")
      document.removeEventListener("click", this._onOutsideClick)
    }
  }

  disconnect() {
    document.removeEventListener("click", this._onOutsideClick)
  }
}
