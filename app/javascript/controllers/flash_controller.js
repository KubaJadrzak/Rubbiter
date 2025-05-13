import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["flash"];

    connect() {
        this.clearFlash();
    }

    clearFlash() {
        const flashElement = this.flashTarget;

        if (flashElement) {
            setTimeout(() => {
                flashElement.innerHTML = "";
            }, 3000);
        }
    }
}