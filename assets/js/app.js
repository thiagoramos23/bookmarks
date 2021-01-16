// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import "alpinejs"

let Hooks = {}
Hooks.Modal = {
  mounted() {
    window.modalHook = this
  },
  destroyed() {
    window.modalHook = null
  },
  modalClosing(leave_duration) {
    setTimeout(() => {
      var selector = '#' + this.el.id
      if (document.querySelector(selector)) {
        this.pushEventTo(selector, 'modal-closed', {})
      }
    }, leave_duration);
  }
}

Hooks.ConnectionStatus = {
  mounted() {
    window.connected = true
  },
  disconnected() {
    window.connected = false
  },
  reconnected() {
    window.connected = true
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to)
      }
    }
  },
  params: {
    _csrf_token: csrfToken
  }
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

