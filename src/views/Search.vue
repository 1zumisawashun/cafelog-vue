<template>
  <div class="all-container">
    <div class="header">
      <div class="search-bar">
        <p>行きたいカフェを探そう</p>
        <!-- eslint-disable -->
        <!--v-onでなくてもイベントが発生できている -->
        <el-input :oninput="isDisplayChange()" v-model="keyword" placeholder="カフェ名" clearable></el-input>
        <el-input
        :oninput="isDisplayChange()"
          v-model="keyword2"
          placeholder="最寄り駅"
          clearable
        ></el-input>
      </div>
    </div>
    <div class="search-button-container" v-show="isDisplay" >
      
        <div class="search-button wifi-button"><router-link :to="{ name: 'Filter', params: { value: 'wifi' }}"
        class="search-content">
          <span class="main-message">Wi-Fiがある場所</span><br> 
          <span class="sub-message">
          勉強する為にはWi-Fiがないと始まりません。カフェに入ってからWi-Fiが無いというトラブルに陥らないように事前に確認しましょう。</span>
          </router-link></div>
        <div class="search-button date-button"><router-link :to="{ name: 'Filter', params: { value: 'date' }}"
        class="search-content"
        >
        
        <span class="main-message">デートにお勧めしたいカフェ</span><br> 
          <span class="sub-message">
            デートに適したカフェを選ぶことによって恋人との関係をさらに深めることができます。いざというときにお洒落なお店を知っていると便利です。
          </span>
        
        </router-link></div>
        <div class="search-button studying-button"><router-link :to="{ name: 'Filter', params: { value: 'studying' }}"
        class="search-content"
        >
        
       <span class="main-message">勉強しやすいカフェ</span><br> 
          <span class="sub-message">
            Wi-Fiはあるけど家族連れや雑音が激しいお店だと集中して勉強できません。ここではカフェで勉強しやすい環境を皆さんに共有したいと思います。
          </span>

        </router-link></div>
        <!-- <div class="search-button"><router-link :to="{ name: 'Filter', params: { value: 'nearplace' }}"
        class="search-content">駅から近い場所で検索する</router-link></div> -->
        <div class="search-button goodcoffee-button"><router-link :to="{ name: 'Filter', params: { value: 'goodcoffee' }}"
        class="search-content">
        
        <span class="main-message">コーヒー通にお勧めしたいカフェ</span><br> 
          <span class="sub-message">
            普段コーヒーを飲んでいていつもと違うスペシャリティコーヒーを求めている方に是非ご覧いただいきたいカフェを特集いたしました。
          </span>

        </router-link></div>
        <div class="search-button coffeestand-button"><router-link :to="{ name: 'Filter', params: { value: 'coffeestand' }}"
        class="search-content">
        
        <span class="main-message">コーヒースタンド</span><br> 
          <span class="sub-message">
            お店で飲むコーヒー以外にもコーヒースタンドで飲むコーヒーも美味しいです。都会の散歩のお供にどこにあるのかお勧めします。
          </span>

        </router-link></div>
        <div class="search-button stayalone-button"><router-link :to="{ name: 'Filter', params: { value: 'stayalone' }}"
        class="search-content">
        
        <span class="main-message">一人で過ごしやすいカフェ</span><br> 
          <span class="sub-message">
            一人でカフェに入ることに抵抗がある人はいませんか？そんな方にもお勧めできる落ち着いたカフェを知っていただきたいです。
          </span>

        </router-link></div>
    </div>
<!-- <div class="posts-container">
      <Card
        class="card l-card"
        v-for="(post, index) in this.wifiblock"
        :key="index"
        :post="post"
      ></Card>
    </div> -->
    <div class="posts-container" >
      <Card
        class="card l-card"
        v-show="isNotDisplay"
        v-for="(post, index) in this.itemsFiltered"
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
      isDisplay: true,
      isNotDisplay: false
    };
  },
  components: {
    //StarRating,
    Card
  },
  methods: {
    //collectionGroupから無理やり取得しなくても自力でできる
    //後で試してみる
    wifiFiltered() {
      for (var i in this.posts) {
        var post = this.posts[i];
        if (String(post.wifi).indexOf("true") !== -1) {
          this.wifiblock.push(post);
        }
      }
      this.searchWord = "wifiblock";
      this.isDisplay = false;
    },
    isDisplayChange() {
      console.log("検索されています");
      console.log(this.isNotDisplay);
      //&&を使用することで両方との検索対象にすることができる
      if (this.keyword == "" && this.keyword2 == "") {
        this.isDisplay = true;
        this.isNotDisplay = false;
      } else {
        this.isDisplay = false;
        this.isNotDisplay = true;
      }
    }
  },
  computed: {
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
    //最初にポストデータをすべて取得する
    db.collection("posts")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data() });
          console.log(doc.data());
          console.log(doc.id);
        });
      });
  }
};
</script>

<style scoped>
.header {
  width: 100%;
  height: 325px;
  background-image: url("../assets/test15.jpg");
  background-size: contain;
  position: relative;
}
/* 
透過した黒を上から重ねるイメージ 
.header::before {
  background-color: rgba(0, 0, 0, 0.4);
   自由に位置指定 
  position: absolute;
  width: 100%;
  height: 325px;
  content: " ";
} */
.search-bar {
  padding-left: 20%;
  width: 60%;
  margin: 0 auto;
  padding-top: 100px;
  text-align: center;
  position: absolute;
}
/* .search-bar p {
  color: white;
  font-weight: bold;
  font-size: 30px;
} */
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
.search-content {
  width: 90%;
  padding: 10% 5%;
  text-align: center;
  position: absolute;
  text-decoration: none;
}
p {
  color: white;
  font-weight: bold;
  font-size: 25px;
  margin-bottom: 10px;
}
.search-button-container {
  width: 85%;
  height: auto;
  margin: 0 auto;
  /* 下二つの要素はないと機能しない */
  display: flex;
  flex-wrap: wrap;
  padding: 0 2%;
}

/* 透過した黒を上から重ねるイメージ  */
.wifi-button::before,
.date-button::before,
.studying-button::before,
.goodcoffee-button::before,
.coffeestand-button::before,
.stayalone-button::before {
  background-color: rgba(0, 0, 0, 0.4);
  /* 自由に位置指定  */
  position: absolute;
  left: 0;
  /* これを入れないと上手く被せられない  */
  width: 100%;
  height: 200px;
  content: "";
}

.wifi-button {
  background-image: url("../assets/freewifi1.jpg");
  background-size: cover;
  /* backgroud-image,sizeはセットで使う */
  width: 30%;
  height: 200px;
  margin: 1% 1% 1% 2%;
  position: relative;
}
.date-button {
  background-image: url("../assets/date2.jpg");
  background-size: cover;
  /* backgroud-image,sizeはセットで使う */
  width: 30%;
  height: 200px;
  margin: 1%;
  position: relative;
}
.studying-button {
  background-image: url("../assets/studying.jpg");
  background-size: 100%;
  /* backgroud-image,sizeはセットで使う */
  width: 30%;
  height: 200px;
  margin: 1% 2% 1% 1%;
  position: relative;
}
.goodcoffee-button {
  background-image: url("../assets/test2.jpg");
  background-size: cover;
  /* backgroud-image,sizeはセットで使う */
  width: 30%;
  height: 200px;
  margin: 1% 1% 1% 2%;
  position: relative;
}
.coffeestand-button {
  background-image: url("../assets/coffeecar.jpg");
  background-size: cover;
  /* backgroud-image,sizeはセットで使う */
  width: 30%;
  height: 200px;
  margin: 1%;
  position: relative;
}
.stayalone-button {
  background-image: url("../assets/coffeebreak.jpg");
  background-size: cover;
  /* backgroud-image,sizeはセットで使う */
  width: 30%;
  height: 200px;
  margin: 1% 2% 1% 1%;
  position: relative;
}

.main-message {
  color: white;
  font-weight: bold;
  font-size: 17px;
}
.sub-message {
  color: white;
  font-size: 13px;
}

@media screen and (max-width: 479px) {
  .card {
    width: 46%;
    height: auto;
    margin: 2%;
  }
  .all-container {
    padding-bottom: 67.5px;
    min-height: 675px;
  }
  .header {
    width: 100%;
    height: 225px;
    background-image: url("../assets/header.jpg");
    background-size: cover;
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
  .search-content {
    width: 90%;
    padding: 3% 5%;
    text-align: center;
    position: absolute;
  }
  p {
    color: white;
    font-weight: bold;
    font-size: 20px;
    margin-bottom: 10px;
  }
  .posts-container {
    width: 95%;
  }
  .search-button-container {
    width: 100%;
    height: auto;
    padding: 0;
  }
  .search-button {
    width: 96%;
    height: 120px;
    margin: 2%;
    position: relative;
  }
  /* 透過した黒を上から重ねるイメージ */
  .search-button::before {
    background-color: rgba(0, 0, 0, 0.4);
    /* 自由に位置指定 */
    position: absolute;
    left: 0;
    /* これを入れないと上手く被せられない */
    width: 100%;
    height: 120px;
    content: "";
  }
  .main-message {
    color: white;
    font-weight: bold;
  }
  .sub-message {
    color: white;
    font-size: 8px;
  }
}
</style>
