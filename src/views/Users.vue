<template>
  <div class="all-container">
    <!--eslint-disable-->
    <el-tabs
      v-model="activeName"
      @tab-click="handleClick"
      class="tab-container"
    >
      <!-- <el-tab-pane label="USER" name="first">
        <div v-for="(user, index) in users" :key="index">
          <p>{{ user.name }}さんのマイページ</p>
          <img :src="user.thumbnail" class="thumbnail" />
          <p>{{ user.email }}</p>
        </div>
      </el-tab-pane> -->
      <el-tab-pane label="POSTED" name="first">
        <div class="posts-container">
          <Card
            class="card l-card"
            v-for="(post, index) in this.posts"
            :key="index"
            :post="post"
          ></Card>
        </div>
      </el-tab-pane>
      <el-tab-pane label="LIKED" name="second">
        <div class="posts-container">
          <Card
            class="card l-card"
            v-for="(post, index) in this.likes"
            :key="index"
            :post="post"
          ></Card>
          <!-- likesCollectionの中身はCard.vueの中身とは異なるため
          良いね機能の色が変わらなかったり星評価機能の表示がされなかったりする。 -->
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { db } from "@/firebase";
import Card from "@/components/Card";
export default {
  data() {
    return {
      users: [],
      name: "",
      posts: [],
      likes: [],
      likesFiltered: [],
      eraseElement: true,
      activeName: "first"
    };
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  methods: {
    handleClick(tab, event) {
      console.log(tab, event);
    }
  },
  components: {
    //StarRating,
    Card
  },
  mounted() {
    console.log(this.likes);

    db.collection("users")
      .where("id", "==", this.$route.params.id)
      .limit(1)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.users.push(doc.data());
          console.log(doc.data());
          console.log(this.users);
        });
      });
    db.collection("posts")
      .where("user.id", "==", this.$route.params.id)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.posts.push({ id: doc.id, ...doc.data(), daisuki: false });
          console.log(doc.data().cafename);
          console.log(this.posts);
          console.log(doc.data().id);
        });
      });

    if (this.$route.params.id === this.user.uid) {
      this.eraseElement = false;
    }
    // // ここからいい機能の一覧表示の部分になる
    db.collectionGroup("likes")
      //collectionGroupではwhereを使用することはできない
      .get()
      .then(querySnapshot => {
        console.log(querySnapshot);
        querySnapshot.forEach(doc => {
          console.log(doc.data().currentUser);
          //これがwhereの役割をしている
          if (doc.data().currentUser === this.user.uid) {
            this.likes.push({
              id: doc.id,
              ...doc.data(),
              daisuki: false
              //星評価が出ないのはlikescollectionにはratingのデータがないため表示されない。
            });
          }
        });
      });
  }
};
</script>

<style scoped>
.all-container {
  width: 100%;
  height: auto;
  min-height: 565px;
  padding: 4% 0 4% 4%;
}
.tab-container {
  width: 90%;
  height: auto;
  background-color: white;
  padding: 15px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  border-radius: 10px;
}

.posts-container {
  width: 95%;
  height: auto;
  margin: 0 auto;
  flex-wrap: wrap;
  display: flex;
  margin-top: 1%;
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

.card {
  width: 18%;
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
  .card {
    width: 46%;
    height: auto;
    margin: 2%;
  }
  .content {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
  .all-container {
    width: 100%;
    min-height: 675px;
    padding: 5% 0 67.5px 0;
  }

  .tab-container {
    width: 90%;
    margin: 0 auto;
    height: auto;
    background-color: #f1f1f1;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
    padding: 10px;
  }
  .posts-container {
    width: 100%;
    height: auto;
    margin: 0 auto;
    flex-wrap: wrap;
    display: flex;
  }
}
</style>
