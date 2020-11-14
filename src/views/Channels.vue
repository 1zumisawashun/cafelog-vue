<template>
  <div class="all-container">
    <p>相手から</p>
    <!-- eslint-disable -->
    <div v-for="(posted, index) in postedChannels" :key="`second-${index}`">
      <div class="card-container">
        <div class="image-container">
          <img :src="posted.thumbnail" class="image" />
        </div>
        <div class="link-container">
          <router-link :to="`/channels/${posted.id}`">
            <p class="chat-name">
              {{ posted.name }}
            </p>
          </router-link>
        </div>
        <div class="button-container">
          <el-button
            type="danger"
            icon="el-icon-delete"
            circle
            @click="deleteChat(posted.id)"
          ></el-button>
        </div>
      </div>
    </div>

    <p>自分から</p>
    <div v-for="(current, index) in currentChannels" :key="`third-${index}`">
      <div class="card-container">
        <div class="image-container">
          <img :src="current.thumbnail" class="image" />
        </div>
        <div class="link-container">
          <router-link :to="`/channels/${current.id}`">
            <p class="chat-name">
              {{ current.name }}
            </p>
          </router-link>
        </div>
        <div class="button-container">
          <el-button
            type="danger"
            icon="el-icon-delete"
            circle
            @click="deleteChat(current.id)"
          ></el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { db } from "@/firebase";
export default {
  data() {
    return {
      postedChannels: [],
      currentChannels: []
    };
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  methods: {
    deleteChat(id) {
      db.collection("channels")
        .doc(id)
        .delete()
        .then(() => {
          window.alert("削除しました！");
        });
    }
  },
  mounted() {
    db.collection("channels")
      .where("postedUser", "==", this.user.uid)
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          /*eslint-disable*/
          const doc = change.doc;
          if (change.type === "added") {
            this.postedChannels.push({ id: doc.id, ...doc.data() });
          } else if (change.type === "removed") {
            const num = this.postedChannels.length - 1;
            const element = this.postedChannels;
            for (let i = 0; i <= num - 1; i++) {
              if (doc.id === element[i].id) {
                this.postedChannels.splice(i, 1);
              }
              console.log(element[i].id);
            }
          }
        });
      });

    db.collection("channels")
      .where("currentUser", "==", this.user.uid)
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          /*eslint-disable*/
          const doc = change.doc;
          if (change.type === "added") {
            this.currentChannels.push({ id: doc.id, ...doc.data() });
          } else if (change.type === "removed") {
            const num = this.currentChannels.length - 1;
            const element = this.currentChannels;
            for (let i = 0; i <= num - 1; i++) {
              if (doc.id === element[i].id) {
                this.currentChannels.splice(i, 1);
              }
              console.log(element[i].id);
            }
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
}
.card-container {
  width: 100%;
  height: auto;
  padding: 15px 0;
  border-radius: 10px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  display: flex;
  background-color: white;
  margin-bottom: 5px;
}
.chat-name {
  width: 100%;
  height: auto;
  padding-top: 20px;
  text-align: left;
}

.image {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  object-fit: cover;
  margin: 10px;
}
.image-container {
  width: 15%;
  height: auto;
}
.link-container {
  width: 70%;
  height: auto;
}
.button-container {
  width: 15%;
  height: auto;
  text-align: center;
  margin-top: 10px;
}

@media screen and (max-width: 479px) {
  .image-container {
    width: 25%;
  }
  .link-container {
    width: 60%;
  }
  .button-container {
    width: 15%;
  }
}
</style>
