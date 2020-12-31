import Vue from "vue";
import VueRouter from "vue-router";
//import Channel from "@/views/Channel.vue";
import Users from "@/views/Users.vue";
import Posts from "@/views/Posts.vue";
import Post from "@/views/Post.vue";
//import Channels from "@/views/Channels.vue";
import Search from "@/views/Search.vue";
//import Test from "@/views/Test.vue";
import Filter from "@/views/Filter.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: Posts,
    component: Posts
  },

  {
    path: "/search",
    name: "Search",
    component: Search
  },
  {
    path: "/filter",
    name: "Filter",
    component: Filter
  },

  // {
  //   path: "/channels",
  //   name: Channels,
  //   component: Channels
  // },
  // {
  //   path: "/channels/:id",
  //   name: Channel,
  //   component: Channel
  // },
  {
    path: "/users/:id",
    name: Users,
    component: Users
  },
  {
    path: "/users/posts/:id",
    component: Post
  },
  {
    path: "/posts",
    name: Posts,
    component: Posts
  },
  {
    path: "/posts/:id",
    name: Post,
    component: Post
  }
  // {
  //   path: "/test",
  //   name: Test,
  //   component: Test
  //}
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
