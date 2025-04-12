// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["sectionA", "sectionB"];

    connect() {
      console.log("Sidebar controller connected!");
    }
  
    toggleSection() {
      console.log("Toggling sidebar sections!");
      // Toggle visibility of Sidebar Section A and Section B
      this.sectionATarget.classList.toggle("d-none");
      this.sectionBTarget.classList.toggle("d-none");
    }
}
