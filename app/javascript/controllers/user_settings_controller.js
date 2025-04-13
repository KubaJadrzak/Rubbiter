import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "emailForm", 
    "passwordForm", 
    "rubitsSection", 
    "commentsSection", 
    "likedRubitsSection"
  ]

  connect() {
    console.log("User settings controller connected!")
  }
  
  toggleRubitsSection() {
    this.toggleContent("rubits")
  }

  toggleCommentsSection() {
    this.toggleContent("comments")
  }

  toggleLikedRubitsSection() {
    this.toggleContent("likedRubits")
  }

  toggleEmailForm() {
    // Hide other sections and show email change form
    this.hideAllSections();
    this.emailFormTarget.classList.remove("d-none");
  }

  togglePasswordForm() {
    // Hide other sections and show password change form
    this.hideAllSections();
    this.passwordFormTarget.classList.remove("d-none");
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
    this.emailFormTarget.classList.add("d-none");
    this.passwordFormTarget.classList.add("d-none");
  }
}
