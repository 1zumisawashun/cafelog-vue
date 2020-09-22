import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import VueSlick from "vue-slick";
import jQuery from "jquery";
global.jquery = jQuery;
global.$ = jQuery;
window.$ = window.jQuery = require("jquery");
import * as VueGoogleMaps from "vue2-google-maps";

Vue.use(VueGoogleMaps, {
  load: {
    key: "AIzaSyD4gF9HU4F7dz_aWGynXJ3jgS9qCPufJ10",
    libraries: "places",
    region: "JP",
    language: "ja",
  },
});
Vue.config.productionTip = false;
Vue.use(VueSlick);

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
