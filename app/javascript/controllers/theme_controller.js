import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const saved = localStorage.getItem("magazine-theme") || "light"
    this._apply(saved)
  }

  toggle() {
    const current = document.documentElement.getAttribute("data-theme") || "light"
    const next = current === "dark" ? "light" : "dark"
    localStorage.setItem("magazine-theme", next)
    this._apply(next)
  }

  _apply(theme) {
    document.documentElement.setAttribute("data-theme", theme)
  }
}
