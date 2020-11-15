<template>
  <div class="all-container">
    <div class="responsive-header">
      <div class="title">cafelog</div>
    </div>
    <div class="header">
      <div class="search-bar">
        <p>行きたいカフェを探そう</p>
        <!-- eslint-disable -->
        <el-input v-model="keyword" placeholder="カフェ名" clearable></el-input>
        <el-input
          v-model="keyword2"
          placeholder="最寄り駅"
          clearable
        ></el-input>
      </div>
    </div>
    
    <div class="posts-container">
      <Card
        class="card l-card"
        v-for="(post, index) in this.itemsFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
    

    <Carousel></Carousel>

    <div class="posts-container">
      <Card
        class="card l-card"
        v-for="(post, index) in this.posts2"
        :key="index"
        :post="post"
      ></Card>
    </div>

    <Carousel></Carousel>

    <div class="posts-container">
      <Card
        class="card l-card"
        v-for="(post, index) in this.posts3"
        :key="index"
        :post="post"
      ></Card>
    </div>
    
  </div>
</template>

<script>
import Vue from "vue";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import Carousel from "@/components/Carousel.vue";
Vue.use(ElementUI);
//import StarRating from "vue-star-rating";
import { db } from "@/firebase";
import Card from "@/components/Card";
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
      rating: "",

      currentDate: new Date(),
      posts: [],
      posts2: [],
      posts3: [],
      file: "",
      image: "",
      modal: false,
      //検索用のデータ
      keyword: "",
      keyword2: "",

      beliked: false,
      liked: true,
      likes: []
    };
  },
  components: {
    //StarRating,
    Carousel,
    Card
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
      .orderBy("createdAt", "desc")
      .limit(8)
      //.orderby("createdAt")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data(), daisuki: false });
          //DBには登録されないけれど「いいね」を見分けるために必要な要素
          console.log(doc.data());
          console.log(doc.data().id);
        });
      });

    // 2個目のカフェボックス
    db.collection("posts")
      .where("station", "==", "渋谷")
      .limit(8)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts2.push({ id: doc.id, ...doc.data(), daisuki: false });
          console.log(doc.data());
          console.log(doc.id);
        });
      });

    //3個目のカフェボックス
    db.collection("posts")
      .where("wifi", "==", true)
      .limit(8)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts3.push({ id: doc.id, ...doc.data(), daisuki: false });
        });
      });
  }
};
</script>

<style scoped>
.dislike {
  background-color: red;
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
  padding-top: 100px;
  text-align: center;
  position: absolute;
}
p {
  color: white;
  font-weight: bold;
  font-size: 25px;
}
/* ここからがカードの中身 */
.card {
  width: 23%;
  height: auto;
  margin: 1%;
  background-color: white;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  border-radius: 10px;
}
/* カードの画像 */
.image {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 10px 10px 0 0;
}
/* ユーザのサムネイル */
.thumbnail {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  margin-right: 10px;
}
/* カードの下半分の要素コンテナ */
.content-block {
  padding: 10px;
}
/* お店の名前 */
.content {
  width: 100%;
  height: 27px;
  margin-top: 0;
  font-weight: bold;
  font-size: 17px;
  overflow: hidden;
  /* text-overflow: ellipsis;
  white-space: nowrap; */
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 1;
}
.station {
  font-size: 15px;
  color: #9e9e9e;
  padding-top: 4px;
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
/* 星評価とコメントカウントのコンテナ */
.star-comment-container {
  width: 98%;
  margin: 0 auto;
  display: flex;
}
/* 星評価機能 */
.star-rating {
  display: inline-block;
  width: 45%;
}
/* コメントカウント */
.comment-count {
  display: inline-block;
  margin-left: 8px;
  margin-top: 2px;
}
.save-container {
  display: inline-block;
  margin-left: 8px;
  margin-top: 2.5px;
}
.responsive-header {
  display: none;
}
.responsive-footer {
  display: none;
}

@media screen and (max-width: 479px) {
  .card {
    width: 46%;
    height: auto;
    margin: 2%;
  }
  .posts-container {
    width: 95%;
  }

  /* レスポンシブヘッダーとレスポンシブフッター */
  .header {
    display: none;
  }
  .responsive-header {
    display: block;
    width: 100%;
    height: auto;
    background-color: #f1f1f1;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  }
  .title {
    font-weight: bold;
    text-align: center;
    padding: 10px 0px;
  }
  .all-container {
    padding-bottom: 67.5px;
  }
}
</style>
