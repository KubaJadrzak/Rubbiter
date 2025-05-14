import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "rubitsSection",
    "commentsSection",
    "likedRubitsSection",
    "orderHistorySection"
  ]

  connect() {
    const hash = window.location.hash.replace("#", "")
    if (hash) this.toggleContent(hash)
    else this.toggleContent("rubits")
  }

  toggleRubitsSection() {
    this.updateURLHash("rubits")
    this.toggleContent("rubits")
  }

  toggleCommentsSection() {
    this.updateURLHash("comments")
    this.toggleContent("comments")
  }

  toggleLikedRubitsSection() {
    this.updateURLHash("likedRubits")
    this.toggleContent("likedRubits")
  }

  toggleOrderHistorySection() {
    this.updateURLHash("orderHistory")
    this.toggleContent("orderHistory")
  }

  toggleContent(contentType) {
    this.hideAllSections()
    const section = this[`${contentType}SectionTarget`]
    if (section) section.classList.remove("d-none")
  }

  hideAllSections() {
    this.rubitsSectionTarget.classList.add("d-none")
    this.commentsSectionTarget.classList.add("d-none")
    this.likedRubitsSectionTarget.classList.add("d-none")
    this.orderHistorySectionTarget.classList.add("d-none")
  }

  updateURLHash(fragment) {
    history.replaceState(null, null, `#${fragment}`)
  }
}