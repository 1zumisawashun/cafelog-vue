<template>
  <div class="all-container">
    <div class="responsive-header">
      <div class="title">cafelog</div>
    </div>
    <div class="posts-container" v-show="isWifiBlockDisplay">
      <Card
        class="card l-card"
        v-for="(post, index) in this.wifiFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
    <div class="posts-container" v-show="isDateBlockDisplay">
      <Card
        class="card l-card"
        v-for="(post, index) in this.dateFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
    <div class="posts-container" v-show="isStudyingBlockDisplay">
      <Card
        class="card l-card"
        v-for="(post, index) in this.studyingFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
    <div class="posts-container" v-show="isGoodCoffeeBlockDisplay">
      <Card
        class="card l-card"
        v-for="(post, index) in this.goodcoffeeFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
    <div class="posts-container" v-show="isCoffeeStandBlockDisplay">
      <Card
        class="card l-card"
        v-for="(post, index) in this.coffeestandFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
    <div class="posts-container" v-show="isStayAloneBlockDisplay">
      <Card
        class="card l-card"
        v-for="(post, index) in this.stayaloneFiltered"
        :key="index"
        :post="post"
      ></Card>
    </div>
  </div>
</template>

<script>
import { db } from "@/firebase";
import Card from "@/components/Card";
export default {
  data() {
    return {
      posts: [],
      keyword: "",
      keyword2: "",
      isDateBlockDisplay: false,
      isWifiBlockDisplay: false,
      isStudyingBlockDisplay: false,
      isGoodCoffeeBlockDisplay: false,
      isCoffeeStandBlockDisplay: false,
      isStayAloneBlockDisplay: false,
      dateblock: [],
      wifiblock: [],
      studyingblock: [],
      goodcoffeeblock: [],
      coffeestandblock: [],
      stayaloneblock: []
    };
  },
  components: {
    Card
  },
  methods: {
    //collectionGroupから無理やり取得しなくても自力でできる
    Filtered() {
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.wifi).indexOf("true") !== -1) {
          this.wifiblock.push(post);
        }
      }
    }
  },
  computed: {
    wifiFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.wifi).indexOf("true") !== -1) {
          posts.push(post);
        }
      }
      return posts;
    },
    dateFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.date).indexOf("true") !== -1) {
          posts.push(post);
        }
      }
      return posts;
    },
    studyingFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.studying).indexOf("true") !== -1) {
          posts.push(post);
        }
      }
      return posts;
    },
    goodcoffeeFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.goodcoffee).indexOf("true") !== -1) {
          posts.push(post);
        }
      }
      return posts;
    },
    coffeestandFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.coffeestand).indexOf("true") !== -1) {
          posts.push(post);
        }
      }
      return posts;
    },
    stayaloneFiltered() {
      var posts = [];
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.stayalone).indexOf("true") !== -1) {
          posts.push(post);
        }
      }
      return posts;
    }
  },
  mounted() {
    if (this.$route.params.value == "wifi") {
      this.isWifiBlockDisplay = true;
    }
    if (this.$route.params.value == "date") {
      this.isDateBlockDisplay = true;
    }
    if (this.$route.params.value == "studying") {
      this.isStudyingBlockDisplay = true;
    }
    if (this.$route.params.value == "goodcoffee") {
      this.isGoodCoffeeBlockDisplay = true;
    }
    if (this.$route.params.value == "coffeestand") {
      this.isCoffeeStandBlockDisplay = true;
    }
    if (this.$route.params.value == "stayalone") {
      this.isStayAloneBlockDisplay = true;
    }
    //最初にポストデータをすべて取得する
    db.collection("posts")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data(), daisuki: false });
        });
      });
  }
};
</script>

<style scoped>
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
  min-height: 675px;
}
.posts-container {
  width: 80%;
  height: auto;
  margin: 0 auto;
  flex-wrap: wrap;
  display: flex;
  padding-top: 2%;
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
.responsive-header {
  display: none;
}

@media screen and (max-width: 479px) {
  .card {
    width: 46%;
    height: auto;
    margin: 2%;
  }
  .all-container {
    min-height: 675px;
    padding-bottom: 67.5px;
  }
  .header {
    width: 100%;
    height: 225px;
    background-image: url("../assets/header.jpg");
    position: relative;
  }

  /* 透過した黒を上から重ねるイメージ */
  .header::before {
    background-color: rgba(0, 0, 0, 0.4);
    /* 自由に位置指定 */
    position: absolute;
    width: 100%;
    height: 225px;
    content: " ";
  }
  .search-bar {
    padding-left: 10%;
    width: 80%;
    margin: 0 auto;
    padding-top: 55px;
    text-align: center;
    position: absolute;
  }
  p {
    color: white;
    font-weight: bold;
    font-size: 20px;
  }
  .posts-container {
    width: 95%;
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
}
</style>
