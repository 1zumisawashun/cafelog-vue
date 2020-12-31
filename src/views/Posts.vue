<template>
  <div class="all-container">
    <div class="responsive-header">
      <div class="title">cafelog</div>
    </div>
    <div class="header">
      <img src="../assets/header.jpg" class="header-image" />
      <div class="search-bar">
        <div class="overlay"></div>
        <h1 class="header-title">cafelog</h1>
        <p>one cup at a time, one cafe at a time.</p>
        <ul class="overlay-text">
          <li>
            <!--li なので自動で「・」が付与される-->
            cafelog運営のお手伝いをして<br />
            くれる方募集中です!
          </li>
          <li>
            カフェ投稿数<br />
            計{{ counter }}件
          </li>
        </ul>
      </div>
    </div>
    <!-- eslint-disable -->
    <div class="heading-container">
      <h3>投稿順でカフェを探す</h3>
    </div>
    <div class="posts-container">
      <Card
        class="card l-card"
        v-for="(post, index) in this.posts"
        :key="index"
        :post="post"
      ></Card>
    </div>
    <div class="heading-container">
      <h3>東京都内のカフェを探す</h3>
    </div>
    <Carousel></Carousel>
    <div class="heading-container">
      <h3>渋谷のカフェを探す</h3>
    </div>
    <div class="posts-container">
      <Card
        class="card l-card"
        v-for="(post, index) in this.posts2"
        :key="index"
        :post="post"
      ></Card>
    </div>
<div class="heading-container">
      <h3>旅行先でカフェを探す</h3>
    </div>
    <Carousel></Carousel>
<div class="heading-container">
      <h3>Wi-Fi完備のカフェを探す</h3>
    </div>
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
      likes: [],
      counter: ""
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
    }
  },
  mounted() {
    // 一個目のカフェボックス
    db.collection("posts")
      .orderBy("createdAt", "desc")
      .limit(8)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data(), daisuki: false });
          console.log(doc.data());
          console.log(doc.id);
        });
      });

    // db.collection("posts")
    //   .orderBy("createdAt", "desc")
    //   .limit(8)
    //   .onSnapshot(snapshot => {
    //     snapshot.docChanges().forEach(change => {
    //       const doc = change.doc;
    //       if (change.type === "added") {
    //         this.posts.unshift({
    //           id: doc.id,
    //           ...doc.data(),
    //           daisuki: false
    //           //dbには入れないで一つの投稿に判別の為のプロパティを入れる
    //         });
    //       } else if (change.type === "removed") {
    //         this.posts.splice(0, 1);
    //         // limit,orderbyも使う時はremovedも使わなくてはいけない
    //       }
    //       console.log(change.type);
    //       console.log(this.posts);
    //     });
    //   });

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

    //カウンター
    db.collection("posts")
      .get()
      .then(querySnapshot => {
        this.counter = querySnapshot.docs.length;
        console.log(querySnapshot.docs.length);
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
  /* margin-top: 1%; */
}
.header-image {
  width: 100%;
  height: 350px;
  object-fit: cover;
}
.header {
  width: 100%;
  height: 350px;
  /* background-image: url("../assets/picture3.jpg"); */
  /* background-size: contain; */
  position: relative;
  margin: 0 0 10px 0;
}

/* 透過した黒を上から重ねるイメージ  */
.header::before {
  background: rgba(0, 0, 0, 0.05);
  /* 自由に位置指定  */
  position: absolute;
  width: 100%;
  height: 350px;
  content: " ";
}

.search-bar {
  padding-left: 20%;
  width: 60%;
  margin: 0 auto;
  padding-top: 100px;
  text-align: center;
  position: absolute;
  top: 0;
  left: 0;
}
.header-title {
  color: #4a4141;
  font-weight: bold;
  font-size: 80px;
  margin-bottom: 10px;
}
p {
  color: #4a4141;
  font-weight: bold;
  font-size: 25px;
  margin-bottom: 10px;
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
.heading-container {
  width: 80%;
  margin: 0 auto;
}

h3 {
  padding: 0 5px; /*上下 左右の余白*/
  margin: 5px 15px;
  color: #494949; /*文字色*/
  background: transparent; /*背景透明に*/
  border-left: solid 5px #494949; /*左線*/
}
.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 0;
  height: 0;
  border-top: 140px solid rgba(0, 0, 0, 0.5);
  border-right: 270px solid transparent;
  border-bottom: 140px solid transparent;
  border-left: 270px solid rgba(0, 0, 0, 0.5);
}
.overlay-text {
  position: absolute;
  color: white;
  text-align: left;
  top: 0%;
  left: 0%;
  margin: 32px 0 0 45px;
  font-size: 22px;
  font-weight: bold;
}
li {
  margin: 0 0 10px 0;
}
li::first-line {
  margin-left: -1em;
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
  .heading-container {
    width: 90%;
    margin: 0 auto;
  }
  h3 {
    margin: 10px 0 0 0;
  }
}
</style>
