// app/javascript/packs/application.js

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

window.Rails = Rails;
if (Rails.root == null) {
  Rails.start();
}

Turbolinks.start()
ActiveStorage.start()