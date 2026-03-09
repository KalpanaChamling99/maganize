import { Controller } from "@hotwired/stimulus"

const KEY = "magazine_bookmarks"

export default class extends Controller {
  connect() {
    const meta = document.querySelector('meta[name="article-id"]')
    if (meta && meta.content) {
      this.articleId = parseInt(meta.content, 10)
    }
    this._render()
    this._syncCount()
  }

  // ── private ────────────────────────────────────────────────

  _render() {
    if (!this.articleId) return
    const saved = this._getIds().includes(this.articleId)
    this.element.dataset.saved = saved
    this.element.setAttribute("aria-label", saved ? "View bookmarks (saved)" : "View bookmarks")
  }

  _syncCount() {
    const count = this._getIds().length
    const badge = this.element.querySelector("[data-bookmark-count]")
    if (!badge) return
    badge.textContent = count
    badge.style.display = count > 0 ? "inline-flex" : "none"
  }

  _getIds() {
    try { return JSON.parse(localStorage.getItem(KEY) || "[]") } catch { return [] }
  }
}
