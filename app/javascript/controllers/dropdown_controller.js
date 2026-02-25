import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "chevron"]
  static values  = { open: Boolean }

  connect() {
    // Set initial height without animation
    if (this.openValue) {
      this.menuTarget.style.maxHeight = this.menuTarget.scrollHeight + "px"
      this.chevronTarget.style.transform = "rotate(180deg)"
    } else {
      this.menuTarget.style.maxHeight = "0px"
    }
    this.menuTarget.style.transition = "max-height 0.25s ease, opacity 0.2s ease"
    this.menuTarget.style.overflow   = "hidden"
  }

  toggle() {
    this.openValue ? this._close() : this._open()
  }

  _open() {
    this.openValue = true
    this.menuTarget.style.maxHeight = this.menuTarget.scrollHeight + "px"
    this.chevronTarget.style.transform = "rotate(180deg)"
  }

  _close() {
    this.openValue = false
    this.menuTarget.style.maxHeight = "0px"
    this.chevronTarget.style.transform = "rotate(0deg)"
  }
}
