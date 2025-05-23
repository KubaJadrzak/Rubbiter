import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loadMoreLink"];

  connect() {
    this.handleScroll = this.checkScroll.bind(this);
    window.addEventListener("scroll", this.handleScroll);

    if (this.hasLoadMoreLinkTarget) {
      this.loadMoreLinkTarget.style.display = 'none';
    }
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll);
  }

  checkScroll = () => {
    const nearBottom = window.innerHeight + window.scrollY >= document.body.offsetHeight - 200;

    if (nearBottom) {
      const link = document.getElementById("load-more-link");
      if (link) {
        link.click();
      }
    }
  };
  loadMore(event) {
    event.preventDefault();
    const link = event.target;
    const url = link.href;

    fetch(url, {
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    })
      .then(response => response.text())
      .then(html => {
        const container = document.getElementById('rubits-list-root');
        container.insertAdjacentHTML('beforeend', html);
        link.style.display = 'none';
      });
  }
}
