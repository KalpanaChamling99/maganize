import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  connect() {
    this.tomSelect = new TomSelect(this.element, {
      plugins: ["remove_button", "checkbox_options"],
      maxOptions: null,
      placeholder: "Search and select articles…",
      allowEmptyOption: false,
      closeAfterSelect: false,
      hidePlaceholder: false,
    })
  }

  disconnect() {
    if (this.tomSelect) {
      this.tomSelect.destroy()
    }
  }
}
