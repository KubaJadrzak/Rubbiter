import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

  }
  static targets = [
    "rubitsSection",
    "commentsSection",
    "likedRubitsSection",
    "orderHistorySection"
  ]

  toggleRubitsSection() {
    this.toggleContent("rubits")
  }

  toggleCommentsSection() {
    this.toggleContent("comments")
  }

  toggleLikedRubitsSection() {
    this.toggleContent("likedRubits")
  }
  toggleOrderHistorySection() {
    this.toggleContent("orderHistory")
  }


  toggleContent(contentType) {
    this.hideAllSections();

    if (contentType === "rubits") {
      this.rubitsSectionTarget.classList.remove("d-none");
    } else if (contentType === "comments") {
      this.commentsSectionTarget.classList.remove("d-none");
    } else if (contentType === "likedRubits") {
      this.likedRubitsSectionTarget.classList.remove("d-none");
    } else if (contentType === "orderHistory") {
      this.orderHistorySectionTarget.classList.remove("d-none");
    }
  }


  hideAllSections() {
    this.rubitsSectionTarget.classList.add("d-none");
    this.commentsSectionTarget.classList.add("d-none");
    this.likedRubitsSectionTarget.classList.add("d-none");
    this.orderHistorySectionTarget.classList.add("d-none");
  }
}
