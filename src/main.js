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
import StarRating from "vue-star-rating";
import VoerroTagsInput from "@voerro/vue-tagsinput";
import dotenv from "dotenv";
//import VuePaginate from "vue-paginate";
dotenv.config();

//------------font-awesome
import { library } from "@fortawesome/fontawesome-svg-core";
import {
  faCoffee,
  faCheck,
  faCheckCircle,
  faHeart,
  faHome,
  faSignOutAlt,
  faSignInAlt,
  faUser,
  faSearch,
  faPaperPlane,
  faUserSecret
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
library.add(
  faCoffee,
  faCheck,
  faCheckCircle,
  faHeart,
  faHome,
  faSignOutAlt,
  faSignInAlt,
  faUser,
  faSearch,
  faPaperPlane,
  faUserSecret
);
Vue.component("font-awesome-icon", FontAwesomeIcon);
//面倒だが推奨に習って一個ずつインポートする必要がある。
//------------font-awesomeここまで
Vue.use(VueGoogleMaps, {
  load: {
    // key: "AIzaSyD4gF9HU4F7dz_aWGynXJ3jgS9qCPufJ10",
    key: "AIzaSyDeBCEsPiM8uPKHdTcrvgL4A01jrKkl5zA",
    //GCPでアップデートしたらAPIも新しく発行された。
    libraries: "places",
    region: "JP",
    language: "ja"
  }
});
Vue.config.productionTip = false;
Vue.use(VueSlick);
Vue.use(StarRating);
Vue.use(VoerroTagsInput);
//Vue.use(VuePaginate);

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
