<template>
  <div>
    <!-- eslint-disable -->
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
        <div
          class="el-icon-collection-tag responsive-save-container dislike"
          v-if="this.post.daisuki"
          @click="unlikes(post)"
        ></div>
        <div
          class="el-icon-collection-tag responsive-save-container like"
          v-else
          @click="likes(post)"
        ></div>
        <div class="star-comment-container">
          <StarRating
            v-model="post.rating"
            :read-only="true"
            v-bind:max-rating="5"
            inactive-color="#9e9e9e"
            active-color="#E6E635"
            v-bind:star-size="18"
            :show-rating="false"
            class="star-rating"
          ></StarRating>
          <div
            class="el-icon-collection-tag save-container dislike"
            v-if="this.post.daisuki"
            @click="unlikes(post)"
          ></div>
          <div
            class="el-icon-collection-tag save-container like"
            v-else
            @click="likes(post)"
          ></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import StarRating from "vue-star-rating";
import { db } from "@/firebase";
export default {
  data() {
    return {
      commentCounts: [],
      likesFiltered: []
    };
  },
  props: ["post"],
  components: {
    StarRating
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  methods: {
    //LikesCollectionとpostsCollection両方のdbをいじって表示を変更させる。
    likes(post) {
      console.log(post);
      db.collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(this.user.uid)
        .set({
          //setはaddと違いしていたidにデータをいれることができる。
          //一番上に来るのがidに当てはめられる
          id: post.id,
          cafename: post.cafename,
          station: post.station,
          image: post.image,
          user: {
            id: post.user.id,
            name: post.user.name,
            thumbnail: post.user.thumbnail
          },
          currentUser: this.user.uid
        });
      alert("「いいね」を付けました。");
    },
    unlikes(post) {
      db.collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(this.user.uid)
        .delete();
      post.daisuki = false;
      alert("「いいね」を消しました。");
    }
  },
  //いいねの色を変えるのは共通で必要になる機能なのでcard.vueで定義する
  mounted() {
    db.collectionGroup("likes")
      //collectionGroupではwhereを使用することはできないため全部のユーザデータを取得
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          const doc = change.doc;
          if (change.type === "added") {
            //「いいね」を押した瞬間に以下if文のアクションをする
            if (doc.data().currentUser === this.user.uid) {
              this.likesFiltered.push({
                id: doc.id,
                ...doc.data()
              });
              for (var i in this.likesFiltered) {
                //上記のfor文の使い方だと数字が入るようになる。条件式に注目する。
                if (this.likesFiltered[i].cafename == this.post.cafename) {
                  this.post.daisuki = true;
                  console.log(this.likesFiltered);
                  //一時的に一個ずつの配列に組み込むことで解決できるのではないか？
                  //リロード時や変更した時はlikescollectionにはないから色が変更しない。
                }
              }
            }
          }
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
  padding-top: 50px;
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
.responsive-save-container {
  display: none;
}

@media screen and (max-width: 479px) {
  .image {
    height: 115px;
  }
  /* ユーザのサムネイル */
  .thumbnail {
    /* width: 25px;
    height: 25px; */
    display: none;
  }
  /* カードの下半分の要素コンテナ */
  .content-block {
    padding: 7px;
  }
  /* お店の名前 */
  .content {
    height: 40px;
    margin-top: 0;
    font-size: 13px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
  .station {
    font-size: 12px;
    padding-top: 2px;
  }
  /* カフェイメージの被さる要素 */
  .more-text {
    transition: 0.5s;
    transition: opacity 0.5s, transform 0.8s;
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -80%);
    display: inline-block;
    padding: 6px 8px 8px;
    color: #fff;
    font-size: 10px;
    border: 1px solid #fff;
    opacity: 0;
  }
  /* 星評価とコメントカウントのコンテナ */
  .star-comment-container {
    display: none;
  }

  .responsive-save-container {
    display: block;
    margin: 4px 0px 0px auto;
  }
}
</style>
