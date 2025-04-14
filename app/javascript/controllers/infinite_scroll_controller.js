import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["loadMoreLink"];

  connect() {
    window.addEventListener("scroll", this.checkScroll);
  }

  disconnect() {
    window.removeEventListener("scroll", this.checkScroll);
  }

  checkScroll = () => {
    const nearBottom = window.innerHeight + window.scrollY >= document.body.offsetHeight - 200;

    if (nearBottom) {
      const link = document.getElementById("load-more-link");
      if (link) {
        link.click(); // Auto-click the link to load more
      }
    }
  };
}
