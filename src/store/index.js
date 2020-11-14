import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: null,
    like: false,
  },
  getters: {
    isAuthenticated(state) {
      return !!state.user;
    },
    isLiked(state) {
      return !!state.like;
    },
  },
  mutations: {
    setUser(state, payload) {
      state.user = payload;
    },
    setLike(state, payload) {
      state.like = payload;
    },
    // addFavorite(state, payload) {
    //   state.item = payload;
    //   console.log(payload);
    // }
  },
  actions: {
    setUser(context, user) {
      context.commit("setUser", user);
    },
    setLike(context, like) {
      context.commit("setLike", like);
    },
  },
});
