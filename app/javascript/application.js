// app/javascript/application.js
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Turbo } from "@hotwired/turbo-rails"

Turbo.session.drive = false

const application = Application.start()
eagerLoadControllersFrom("controllers", application)