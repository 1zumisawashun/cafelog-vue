import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: null
  },
  getters: {
    isAuthenticated(state) {
      return !!state.user;
    }
  },
  mutations: {
    setUser(state, payload) {
      state.user = payload;
    }
  },
  actions: {
    setUser(context, user) {
      context.commit("setUser", user);
    }
  }
});
