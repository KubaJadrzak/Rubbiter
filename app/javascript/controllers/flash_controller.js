import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["flash"];

    connect() {
        // Listen for the Turbo load event
        this.clearFlash();
    }

    clearFlash() {
        const flashElement = this.flashTarget;

        if (flashElement) {
            setTimeout(() => {
                flashElement.innerHTML = "";
            }, 3000); // Clear flash after 3 seconds
        }
    }
}