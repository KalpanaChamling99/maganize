import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar", "btn", "arc", "pct", "nav", "sentinel", "spacer", "bookmark"]

  static values = { circumference: { type: Number, default: 119.38 } }

  connect() {
    this._update = this.update.bind(this)
    window.addEventListener("scroll", this._update, { passive: true })

    if (this.hasSentinelTarget && this.hasNavTarget) {
      this._observer = new IntersectionObserver(
        ([entry]) => this._toggleFixed(!entry.isIntersecting),
        { threshold: 0 }
      )
      this._observer.observe(this.sentinelTarget)
    }

    this.update()
  }

  disconnect() {
    window.removeEventListener("scroll", this._update)
    this._observer?.disconnect()
  }

  _toggleFixed(fixed) {
    this.navTarget.classList.toggle("is-fixed", fixed)
    const navH = this.navTarget.offsetHeight
    if (this.hasSpacerTarget) {
      this.spacerTarget.style.height = fixed ? navH + "px" : "0"
    }
    if (this.hasBarTarget) {
      this.barTarget.style.top     = fixed ? navH + "px" : "0"
      this.barTarget.style.display = fixed ? "block" : "none"
    }
  }

  update() {
    const scrollTop = window.scrollY || document.documentElement.scrollTop
    const docHeight = document.documentElement.scrollHeight - window.innerHeight
    const ratio     = docHeight > 0 ? scrollTop / docHeight : 0
    const percent   = Math.round(ratio * 100)

    this.barTarget.style.transform        = `scaleX(${ratio})`
    this.arcTarget.style.strokeDashoffset = this.circumferenceValue - ratio * this.circumferenceValue
    this.pctTarget.textContent            = percent + "%"
    this.btnTarget.style.display          = scrollTop > 300 ? "flex" : "none"
    if (this.hasBookmarkTarget) {
      this.bookmarkTarget.classList.toggle("is-visible", scrollTop > 300)
    }
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: "smooth" })
  }

  scrollToSubscribe(event) {
    event.preventDefault()
    document.getElementById("subscribe-cta")?.scrollIntoView({ behavior: "smooth" })
  }
}
