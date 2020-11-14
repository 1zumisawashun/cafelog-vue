<template>
  <div>
    <VueSlickCarousel v-bind="setting" class="slick-carousel-container">
      <div class="slick-box">
        <img :src="posts[5].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[4].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[3].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[2].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[1].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[0].image" />
      </div>
    </VueSlickCarousel>
  </div>
</template>

<script>
import "slick-carousel/slick/slick.css";
import VueSlickCarousel from "vue-slick-carousel";
import "vue-slick-carousel/dist/vue-slick-carousel.css";
// optional style for arrows & dots
import "vue-slick-carousel/dist/vue-slick-carousel-theme.css";
import { db } from "@/firebase";
export default {
  data() {
    return {
      posts: [],
      setting: {
        dots: true,
        slidesToShow: 5,
        infinite: true,
        autoplay: true,
        autoplayTimeout: 1000
      }
    };
  },
  components: {
    VueSlickCarousel
  },
  mounted() {
    db.collection("posts")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data() });
          console.log(doc.data());
          console.log(doc.id);
          console.log(this.posts);
        });
      });
  }
};
</script>

<style scoped>
.slick-carousel-container {
  width: 100%;
  height: auto;
}
.slick-box img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}
.slick-slider {
  margin: 30px 0;
}
@media screen and (max-width: 479px) {
}
</style>
