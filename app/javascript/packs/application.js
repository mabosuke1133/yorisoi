// app/javascript/packs/application.js

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

window.Rails = Rails;
if (Rails.root == null) {
  Rails.start();
}

Turbolinks.start()
ActiveStorage.start()