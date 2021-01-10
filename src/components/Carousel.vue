<template>
  <div class="slick-all-container">
    <VueSlickCarousel v-bind="setting" class="slick-carousel-container">
      <router-link :to="`posts/${posts[0].id}`" class="slick-box">
        <div class="station">{{ posts[0].station }}</div>
        <img :src="posts[0].image" />
      </router-link>
      <router-link :to="`posts/${posts[1].id}`" class="slick-box">
        <div class="station">{{ posts[1].station }}</div>
        <img :src="posts[1].image" />
      </router-link>
      <router-link :to="`posts/${posts[2].id}`" class="slick-box">
        <div class="station">{{ posts[2].station }}</div>
        <img :src="posts[2].image" />
      </router-link>
      <router-link :to="`posts/${posts[3].id}`" class="slick-box">
        <div class="station">{{ posts[3].station }}</div>
        <img :src="posts[3].image" />
      </router-link>
      <router-link :to="`posts/${posts[4].id}`" class="slick-box">
        <div class="station">{{ posts[4].station }}</div>
        <img :src="posts[4].image" />
      </router-link>
      <router-link :to="`posts/${posts[5].id}`" class="slick-box">
        <div class="station">{{ posts[5].station }}</div>
        <img :src="posts[5].image" />
      </router-link>
    </VueSlickCarousel>
  </div>
</template>

<script>
import "slick-carousel/slick/slick.css";
import VueSlickCarousel from "vue-slick-carousel";
import "vue-slick-carousel/dist/vue-slick-carousel.css";
// optional style for arrows & dots
import "vue-slick-carousel/dist/vue-slick-carousel-theme.css";
import _ from "lodash";
//lodashをインポートするために記載が必要
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
        autoplayTimeout: 1000,
        arrows: false
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
          this.shuffle();
        });
      });
  },
  methods: {
    shuffle: function() {
      this.posts = _.shuffle(this.posts); //「_.」はlodashを使うときの宣言。参考:https://lodash.com/
    }
  }
};
</script>

<style scoped>
.slick-all-container {
  max-width: 95%;
  margin: 0 auto;
}
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
/* 透過した黒を上から重ねるイメージ */
.slick-box::before {
  background: rgba(0, 0, 0, 0.08);
  /* 自由に位置指定 */
  position: absolute;
  top: 150px;
  width: 100%;
  height: 50px;
  content: " ";
}
.station {
  top: 160px;
  padding: 0 0 0 10px;
  position: absolute;
  color: white;
  font-weight: bold;
}
@media screen and (max-width: 479px) {
  .slick-all-container {
    max-width: 90%;
    margin: 0 auto;
  }
  .slick-carousel-container {
    width: 100%;
    height: auto;
  }
  .station {
    top: 160px;
    padding: 0;
    position: absolute;
    color: white;
    font-weight: bold;
  }
}
</style>
