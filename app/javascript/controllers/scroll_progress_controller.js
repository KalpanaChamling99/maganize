import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar", "btn", "arc", "pct"]

  static values = { circumference: { type: Number, default: 119.38 } }

  connect() {
    this._update = this.update.bind(this)
    window.addEventListener("scroll", this._update, { passive: true })
    this.update()
  }

  disconnect() {
    window.removeEventListener("scroll", this._update)
  }

  update() {
    const scrollTop = window.scrollY || document.documentElement.scrollTop
    const docHeight = document.documentElement.scrollHeight - window.innerHeight
    const ratio     = docHeight > 0 ? scrollTop / docHeight : 0
    const percent   = Math.round(ratio * 100)

    this.barTarget.style.width               = percent + "%"
    this.arcTarget.style.strokeDashoffset    = this.circumferenceValue - ratio * this.circumferenceValue
    this.pctTarget.textContent               = percent + "%"
    this.btnTarget.style.display             = scrollTop > 300 ? "flex" : "none"
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: "smooth" })
  }
}
