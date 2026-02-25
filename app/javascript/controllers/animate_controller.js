import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const items = this.element.querySelectorAll("[data-animate]")
    if (!items.length) return

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible")
          observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.1, rootMargin: "0px 0px -40px 0px" })

    items.forEach(el => observer.observe(el))
  }
}
