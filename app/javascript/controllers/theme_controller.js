import { Controller } from "@hotwired/stimulus"

const COOKIE_NAME = "magazine-theme"
const COOKIE_MAX_AGE = 1800 // 30 minutes in seconds

export default class extends Controller {
  connect() {
    // Cookie is already applied server-side; sync in case JS loaded late
    const saved = this._readCookie() || "light"
    this._apply(saved)
  }

  toggle() {
    const current = document.documentElement.getAttribute("data-theme") || "light"
    const next = current === "dark" ? "light" : "dark"
    this._writeCookie(next)
    this._apply(next)
  }

  _apply(theme) {
    document.documentElement.setAttribute("data-theme", theme)
  }

  _readCookie() {
    const match = document.cookie.match(/(?:^|;\s*)magazine-theme=([^;]+)/)
    return match ? match[1] : null
  }

  _writeCookie(value) {
    document.cookie = `${COOKIE_NAME}=${value}; max-age=${COOKIE_MAX_AGE}; path=/; SameSite=Lax`
  }
}
