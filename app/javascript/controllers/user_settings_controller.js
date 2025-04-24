import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

  }
  static targets = [
    "emailForm",
    "rubitsSection",
    "commentsSection",
    "likedRubitsSection"
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


  toggleContent(contentType) {
    // Hide all content sections first
    this.hideAllSections();

    // Show the requested section
    if (contentType === "rubits") {
      this.rubitsSectionTarget.classList.remove("d-none");
    } else if (contentType === "comments") {
      this.commentsSectionTarget.classList.remove("d-none");
    } else if (contentType === "likedRubits") {
      this.likedRubitsSectionTarget.classList.remove("d-none");
    }
  }

  // Helper function to hide all sections
  hideAllSections() {
    this.rubitsSectionTarget.classList.add("d-none");
    this.commentsSectionTarget.classList.add("d-none");
    this.likedRubitsSectionTarget.classList.add("d-none");
  }
}
