import { Controller } from "@hotwired/stimulus"

const KEY = "magazine_bookmarks"

export default class extends Controller {
  static values = { articleId: Number }

  connect() {
    this._render()
  }

  toggle(event) {
    event.preventDefault()
    const id   = this.articleIdValue
    const ids  = this._getIds()
    const saved = ids.includes(id)

    this._setIds(saved ? ids.filter(i => i !== id) : [...ids, id])
    this._render()
    this._syncNavCount()
    this.dispatch("changed", { detail: { id, saved: !saved } })
  }

  // ── private ────────────────────────────────────────────────

  _render() {
    const saved = this._getIds().includes(this.articleIdValue)
    this.element.dataset.saved = saved
    this.element.setAttribute("aria-label", saved ? "Remove bookmark" : "Bookmark this article")
  }

  _syncNavCount() {
    const count = this._getIds().length
    document.querySelectorAll("[data-bookmark-count]").forEach(el => {
      el.textContent = count
      el.style.display = count > 0 ? "inline-flex" : "none"
    })
  }

  _getIds() {
    try { return JSON.parse(localStorage.getItem(KEY) || "[]") } catch { return [] }
  }

  _setIds(ids) {
    localStorage.setItem(KEY, JSON.stringify(ids))
  }
}
