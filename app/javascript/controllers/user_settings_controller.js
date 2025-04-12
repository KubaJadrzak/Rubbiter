// app/javascript/controllers/user_settings_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["emailForm", "passwordForm"]

    connect() {
      console.log("User settings controller connected!")
    }
  
    toggleEmailForm() {
      // Show the email form and hide the password form
      this.emailFormTarget.classList.remove("d-none");
      this.passwordFormTarget.classList.add("d-none");
    }
  
    togglePasswordForm() {
      // Show the password form and hide the email form
      this.passwordFormTarget.classList.remove("d-none");
      this.emailFormTarget.classList.add("d-none");
    }
}
