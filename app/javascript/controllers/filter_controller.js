import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pill", "card", "count"]

  connect() {
    this._active = "all"
  }

  apply(event) {
    const btn = event.currentTarget
    const category = btn.dataset.filterCategory

    // If clicking the already-active pill, reset to "all"
    this._active = (this._active === category && category !== "all") ? "all" : category

    // Update pill styles
    this.pillTargets.forEach(p => {
      const isActive = p.dataset.filterCategory === this._active
      p.classList.toggle("filter-pill-active", isActive)
    })

    // Show / hide cards
    let visible = 0
    this.cardTargets.forEach(card => {
      const match = this._active === "all" || card.dataset.filterCategory === this._active
      card.style.display = match ? "" : "none"
      if (match) visible++
    })

    // Update count label if present
    if (this.hasCountTarget) {
      this.countTarget.textContent = this._active === "all"
        ? "Latest Articles"
        : `${visible} article${visible !== 1 ? "s" : ""} in ${btn.textContent.trim()}`
    }
  }
}
