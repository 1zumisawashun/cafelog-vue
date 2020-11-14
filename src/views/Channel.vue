<template>
  <div>
    <div class="container">
      <div class="chats-layout">
        <messages :messages="messages" />
        <div v-for="(image, index) in images" :key="index">
          <img :src="image.user.thumbnail" style="width:100px; height:100px;" />
          <img :src="image.image" style="width:100px; height:100px;" />
        </div>
      </div>
      <div class="input-layout">
        <ChatForm />
      </div>
    </div>
  </div>
</template>

<script>
import { db } from "@/firebase";
import Messages from "@/components/Messages.vue";
import ChatForm from "@/components/ChatForm.vue";

export default {
  components: {
    Messages,
    ChatForm
  },
  data() {
    return {
      messages: [],
      images: []
    };
  },
  watch: {
    $route(to, from) {
      console.log(to);
      console.log(from);
    }
  },
  mounted() {
    //通常のquerysnapshotではなくリアルタイムでの表示を行っている。
    const channelId = this.$route.params.id;
    db.collection("channels")
      .doc(channelId)
      .collection("messages")
      .orderBy("createdAt")
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          /*eslint-disable*/
          const doc = change.doc;
          if (change.type === "added") {
            console.log("New Message :", change.doc.data());
            this.messages.push({ id: doc.id, ...doc.data() });
          } else if (change.type === "removed") {
            console.log("remove message :", change.doc.data());
            console.log(doc.id);
            const num = this.messages.length - 1;
            const element = this.messages;
            for (let i = 0; i <= num - 1; i++) {
              if (doc.id === element[i].id) {
                this.messages.splice(i, 1);
              }
              console.log(element[i].id);
              console.log(this.messages);
            }
          } else if (change.type === "modified") {
            console.log("update message :", change.doc.data());
            this.messages.push({ id: doc.id, ...doc.data() });
          }
        });
      });
    db.collection("channels")
      .doc(channelId)
      .collection("images")
      .orderBy("createdAt")
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          /*eslint-disable*/
          const doc = change.doc;
          if (change.type === "added") {
            console.log("New Images :", change.doc.data());
            this.images.push({ id: doc.id, ...doc.data() });
            console.log(this.images);
          }
        });
      });
  }
};
</script>

<style scoped>
.container {
  height: 100%;
}

/* 以下を追加 */
.chats-layout {
  overflow: scroll;
  height: 90%;
}

.input-layout {
  height: 10%;
}
</style>
