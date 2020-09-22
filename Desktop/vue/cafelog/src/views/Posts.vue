<template>
  <div class="all-container">
    <div class="header">
      <div class="search-bar">
        <p>行きたいカフェを探そう</p>
        <!-- eslint-disable -->
        <el-input v-model="keyword" placeholder="カフェ名" clearable></el-input>
        <el-input v-model="keyword2" placeholder="最寄り駅" clearable></el-input>
      </div>
    </div>
    <div class="posts-container">
      <div
        class="card l-card"
        data-aos="flip-down"
        v-for="(post, index) in this.itemsFiltered"
        :key="index"
      >
        <div class="image-block l-thumbnail">
          <figure class="thumbnail-wrapper">
            <img :src="post.image" class="image" />
          </figure>
          <router-link :to="`posts/${post.id}`">
            <span class="more-text">Read More</span>
          </router-link>
        </div>
        <div class="content-block text-content">
          <div class="content">{{ post.cafename }}</div>
          <div class="posted-user">
            <router-link :to="`/users/${post.user.id}`" class="username">
              <img :src="post.user.thumbnail" class="thumbnail" />
            </router-link>
            <div class="station">{{ post.station }}駅</div>
          </div>
        </div>
      </div>
    </div>

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

    <div class="posts-container">
      <div class="card l-card" data-aos="fade-up" v-for="(post, index) in this.posts2" :key="index">
        <div class="image-block l-thumbnail">
          <figure class="thumbnail-wrapper">
            <img :src="post.image" class="image" />
          </figure>
          <router-link :to="`posts/${post.id}`">
            <span class="more-text">Read More</span>
          </router-link>
        </div>
        <div class="content-block text-content">
          <div class="content">{{ post.cafename }}</div>
          <div class="posted-user">
            <router-link :to="`/users/${post.user.id}`" class="username">
              <img :src="post.user.thumbnail" class="thumbnail" />
            </router-link>
            <div class="station">{{ post.station }}駅</div>
          </div>
        </div>
      </div>
    </div>

    <VueSlickCarousel v-bind="setting" class="slick-carousel-container">
      <div class="slick-box">
        <img :src="posts[0].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[1].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[2].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[3].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[4].image" />
      </div>
      <div class="slick-box">
        <img :src="posts[5].image" />
      </div>
    </VueSlickCarousel>

    <div class="posts-container">
      <div class="card l-card" data-aos="fade-up" v-for="(post, index) in this.posts3" :key="index">
        <div class="image-block l-thumbnail">
          <figure class="thumbnail-wrapper">
            <img :src="post.image" class="image" />
          </figure>
          <router-link :to="`posts/${post.id}`">
            <span class="more-text">Read More</span>
          </router-link>
        </div>
        <div class="content-block text-content">
          <div class="content">{{ post.cafename }}</div>
          <div class="posted-user">
            <router-link :to="`/users/${post.user.id}`" class="username">
              <img :src="post.user.thumbnail" class="thumbnail" />
            </router-link>
            <div class="station">{{ post.station }}駅</div>
          </div>
        </div>
      </div>
    </div>
    <div>
      <GmapMap
        :center="{lat:10, lng:10}"
        :zoom="7"
        map-type-id="terrain"
        style="width: 100%; height: 300px"
      >
        <GmapMarker
          :key="index"
          v-for="(m, index) in markers"
          :position="m.position"
          :clickable="true"
          :draggable="true"
          @click="center=m.position"
        />
      </GmapMap>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import "slick-carousel/slick/slick.css";
import VueSlickCarousel from "vue-slick-carousel";
import "vue-slick-carousel/dist/vue-slick-carousel.css";
// optional style for arrows & dots
import "vue-slick-carousel/dist/vue-slick-carousel-theme.css";
import AOS from "aos"; //ローカルで読み込みをする。なぜならinit()で使うから。
//import "aos/dist/aos.css";
Vue.use(ElementUI);
import { db } from "@/firebase";
export default {
  data() {
    return {
      cafename: "",
      content: "",
      businesshour: "",
      station: "",
      address: "",
      tel: "",
      holiday: "",
      open: false,
      close: "",

      currentDate: new Date(),
      posts: [],
      posts2: [],
      posts3: [],
      file: "",
      image: "",
      modal: false,

      keyword: "",
      keyword2: "",
      //vue-slick-carousellのオプション
      setting: {
        dots: true,
        slidesToShow: 5,
        infinite: true,
        autoplay: true,
        autoplaySpeed: 7000
      }
    };
  },
  components: {
    VueSlickCarousel
  },
  computed: {
    user() {
      return this.$store.state.user;
    },
    itemsFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (
          String(post.station).indexOf(this.keyword2) !== -1 &&
          String(post.cafename).indexOf(this.keyword) !== -1
        ) {
          posts.push(post);
        }
      }
      return posts;
    }
  },
  mounted() {
    // 一個目のカフェボックス
    db.collection("posts")
      .limit(8)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data() });
          console.log(doc.data());
          console.log(doc.id);
        });
      });
    console.log(this.holiday);
    // 2個目のカフェボックス
    db.collection("posts")
      .where("station", "==", "渋谷")
      .limit(8)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts2.push({ id: doc.id, ...doc.data() });
          console.log(doc.data());
          console.log(doc.id);
        });
      });
    console.log(this.holiday);
    //3個目のカフェボックス
    db.collection("posts")
      .where("wifi", "==", true)
      .limit(8)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts3.push({ id: doc.id, ...doc.data() });
          console.log(doc.data());
          console.log(doc.id);
        });
      });
    console.log(this.holiday);
  },
  created() {
    AOS.init({
      duration: 300,

      delay: 100
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
.header {
  width: 100%;
  height: 325px;
  background-image: url("../assets/header.jpg");
  position: relative;
}

/* 透過した黒を上から重ねるイメージ */
.header::before {
  background-color: rgba(0, 0, 0, 0.4);
  /* 自由に位置指定 */
  position: absolute;
  width: 100%;
  height: 325px;
  content: " ";
}
.search-bar {
  padding-left: 20%;
  width: 60%;
  margin: 0 auto;
  padding-top: 50px;
  text-align: center;
  position: absolute;
}
p {
  color: white;
  font-weight: bold;
  font-size: 25px;
}
/* カードの中身 */
.image {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 10px 10px 0 0;
}

.thumbnail {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
}

.all-container {
  width: 100%;
  height: auto;
}
.posts-container {
  width: 80%;
  height: auto;
  margin: 0 auto;
  flex-wrap: wrap;
  display: flex;
  margin-top: 1%;
}

.card {
  width: 23%;
  height: auto;
  margin: 1%;
  background-color: white;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  border-radius: 10px;
}
.content-block {
  padding: 10px;
}
.content {
  width: 100%;
  height: 60px;
  margin-top: 0;
  font-weight: bold;
  font-size: 20px;

  overflow: hidden;
  /* text-overflow: ellipsis;
  white-space: nowrap; */
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}
.station {
  color: #9e9e9e;
  padding-top: 10px;
}
.posted-user {
  display: flex;
  flex-wrap: wrap;
}
.l-thumbnail {
  position: relative;
  overflow: hidden;
  width: 100%;
  height: auto;
}
.thumbnail-wrapper {
  display: block;
  margin: 0;
  padding: 0;
}
.thumbnail-wrapper::after {
  transition: 0.3s;
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  transform: translateY(-100%);
  display: block;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.4);
  opacity: 0.8;
}
.thumbnail-wrapper img {
  display: block;
  max-width: 100%;
}
.more-text {
  transition: 0.5s;
  transition: opacity 0.5s, transform 0.8s;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -80%);
  display: inline-block;
  padding: 6px 12px 8px;
  color: #fff;
  font-size: 14px;
  border: 1px solid #fff;
  opacity: 0;
}
.l-card:hover .thumbnail-wrapper::after {
  transform: translateY(0);
}
.l-card:hover .more-text {
  transform: translate(-50%, -50%);
  opacity: 1;
}

@media screen and (max-width: 479px) {
  .posts-container {
    overflow: hidden;
  }
  .card {
    width: 48%;
    height: auto;
  }

  .content {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
}
</style>
