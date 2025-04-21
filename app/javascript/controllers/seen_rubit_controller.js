import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver(
      entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const rubitId = this.element.dataset.rubitId

            fetch(`/rubits/${rubitId}/mark_seen`, {
              method: "POST",
              headers: {
                "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                "Content-Type": "application/json"
              },
              body: JSON.stringify({})
            })

            this.observer.disconnect() // Stop observing after it's seen once
          }
        })
      },
      {
        threshold: 0.5 // 50% of rubit should be visible to trigger
      }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}
