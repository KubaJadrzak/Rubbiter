# config/importmap.rb

pin "application", preload: true

# Use a CDN like Skypack to pin these dependencies
pin "@hotwired/turbo-rails", to: "https://cdn.skypack.dev/@hotwired/turbo-rails@7.0.0"
pin "@hotwired/stimulus", to: "https://cdn.skypack.dev/@hotwired/stimulus@3.2.2"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Pin all controllers from your app (from your "controllers" folder)
pin_all_from "app/javascript/controllers", under: "controllers"
