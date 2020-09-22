<template>
  <div class="user-container">
    <!--eslint-disable-->
    <el-tabs v-model="activeName" @tab-click="handleClick" class="tab-container">
      <el-tab-pane label="USER" name="first">
        <div v-for="(user, index) in users" :key="index">
          <p>{{ user.name }}さんのマイページ</p>
          <img :src="user.thumbnail" class="thumbnail" />
          <p>{{ user.email }}</p>
        </div>
      </el-tab-pane>
      <el-tab-pane label="POSTED" name="second">
        <div class="posts-container">
          <div class="card l-card" v-for="(post, index) in posts" :key="index">
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
                <div class="station">{{ post.station }}</div>
              </div>
            </div>
          </div>
        </div>
      </el-tab-pane>
      <el-tab-pane label="LIKED" name="third">
        <div class="posts-container">
          <div class="card l-card" v-for="(post, index) in likes" :key="index">
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
                <router-link :to="`/users/${post.username}`" class="username">
                  <img :src="post.thumbnail" class="thumbnail" />
                </router-link>
                <div class="station">{{ post.station }}</div>
              </div>
            </div>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { db } from "@/firebase";
export default {
  data() {
    return {
      users: [],
      name: "",
      posts: [],
      likes: [],

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
  mounted() {
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
          this.posts.push({ id: doc.id, ...doc.data() });
          console.log(doc.data().cafename);
          console.log(this.posts);
          console.log(doc.data().id);
        });
      });

    if (this.$route.params.id === this.user.uid) {
      this.eraseElement = false;
    }

    db.collectionGroup("likes")
      //.where("username", "==", this.user.uid)
      .get()
      .then(querySnapshot => {
        console.log(querySnapshot);
        querySnapshot.forEach(doc => {
          this.likes.push({
            id: doc.id,
            ...doc.data()
          });

          console.log(this.likes);
        });
      });
  }
};
</script>

<style scoped>
.user-container {
  width: 100%;
  height: auto;
  margin-top: 5%;
}

.tab-container {
  width: 90%;
  margin: 0 auto;
  height: auto;
  background-color: white;
  padding: 10px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  border-radius: 10px;
}
.user-posted {
  width: 80%;
  height: auto;
  margin: auto;
  margin: 10px;
  background-color: aliceblue;
  border-radius: 10px;
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
  width: 95%;
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
