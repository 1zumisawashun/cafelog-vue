<template>
  <div class="kaiwa">
    <!--ここからuserのv-if文-->
    <figure class="kaiwa-img-right" v-if="displayRight">
      <img :src="message.user.thumbnail" />
      <figcaption class="kaiwa-img-description">{{ displayName }}</figcaption>
    </figure>
    <figure class="kaiwa-img-left" v-else>
      <img :src="message.user.thumbnail" />
      <figcaption class="kaiwa-img-description">{{ displayName }}</figcaption>
    </figure>
    <!--ここまで-->
    <!--eslint-disable-->
    <!--ここからtextのv-if文-->
    <div class="kaiwa-text-left" v-if="displayRight">
      <p class="kaiwa-text">{{ message.text }}</p>
      <div>
        <img :src="message.image" style="width:200px; height:auto;" />
      </div>
      <el-button
        type="danger"
        icon="el-icon-delete"
        circle
        @click="remove(message.id)"
        v-show="displayButton"
      ></el-button>
      <el-button
        type="primary"
        icon="el-icon-edit"
        circle
        @click="openUpdateModal"
        v-show="displayButton"
      ></el-button>

      <el-dialog title :visible.sync="dialogVisible" width="70%">
        <p>編集内容を記入してください</p>
        <el-input type="text" v-model="updateMessage" :placeholder="message.text"></el-input>
        <el-button @click="update(message.id)">更新する</el-button>
      </el-dialog>
    </div>
    <div class="kaiwa-text-right" v-else>
      <p class="kaiwa-text">{{ message.text }}</p>
      <div>
        <img :src="message.image" style="width:200px; height:auto;" />
      </div>
      <el-button
        type="danger"
        icon="el-icon-delete"
        circle
        @click="remove(message.id)"
        v-show="displayButton"
      ></el-button>
      <el-button
        type="primary"
        icon="el-icon-edit"
        circle
        @click="openUpdateModal"
        v-show="displayButton"
      ></el-button>
      <el-dialog title :visible.sync="dialogVisible" width="70%">
        <p>編集内容を記入してください</p>
        <el-input type="text" v-model="updateMessage" :placeholder="message.text"></el-input>
        <el-button @click="update(message.id)">更新する</el-button>
      </el-dialog>
    </div>
    <!--ここまで-->
  </div>
</template>

<script>
import { db } from "@/firebase";
export default {
  props: ["message"],
  data() {
    return {
      updateMessage: "",
      displayRight: false,
      dialogVisible: false,
      displayButton: false
    };
  },
  computed: {
    displayName() {
      return "@" + this.message.user.name;
    },
    isAuthenticated() {
      return this.$store.getters.isAuthenticated;
    },
    user() {
      return this.$store.state.user;
    }
  },
  methods: {
    remove(id) {
      const channelId = this.$route.params.id;
      console.log(id);
      console.log(channelId);
      db.collection("channels")
        .doc(channelId)
        .collection("messages")
        .doc(id)
        .delete()
        .then(() => {
          alert("メッセージ削除に成功しました");
        });
      //ここではあくまで削除するだけで表示までしていない
    },
    update(id) {
      const channelId = this.$route.params.id;
      console.log(id);
      console.log(channelId);
      db.collection("channels")
        .doc(channelId)
        .collection("messages")
        .doc(id)
        .update({ text: this.updateMessage })
        .then(() => {
          alert("メッセージの更新に成功しました");
        });
    },
    openUpdateModal() {
      this.dialogVisible = true;
    }
  },
  mounted() {
    const postedUser = this.message.user.id;
    const currentUser = this.user.uid;
    if (postedUser === currentUser) {
      this.displayRight = true;
      console.log(this.isAuthenticated);
      console.log(this.user.uid);
      console.log(this.message.user.id);
      this.displayButton = true;
    }
  }
};
</script>

<style scoped>
.kaiwa {
  margin-bottom: 25px;
}
/* 左画像 */
.kaiwa-img-left {
  margin: 0;
  float: left;
  width: 60px;
  height: 60px;
  margin-right: -70px;
}
/* 右画像 */
.kaiwa-img-right {
  margin: 0;
  float: right;
  width: 60px;
  height: 60px;
  margin-left: -70px;
}
.kaiwa figure img {
  width: 100%;
  height: 100%;
  border: 1px solid #aaa;
  border-radius: 50%;
  margin: 0;
}
/* 画像の下のテキスト */
.kaiwa-img-description {
  padding: 10px 0 0;
  font-size: 10px;
  text-align: center;
  position: relative;
  bottom: 15px;
}
/* 左からの吹き出しテキスト */
.kaiwa-text-right {
  position: relative;
  margin-left: 80px;
  padding: 10px;
  border-radius: 10px;
  background: lightgray;
  margin-right: 12%;
  float: left;
}
/* 右からの吹き出しテキスト */
.kaiwa-text-left {
  position: relative;
  margin-right: 80px;
  padding: 10px;
  border-radius: 10px;
  background-color: lightgreen;
  margin-left: 12%;
  float: right;
}
p.kaiwa-text {
  margin: 0 0 20px;
}
p.kaiwa-text:last-child {
  margin-bottom: 0;
}
/* 左の三角形を作る */
.kaiwa-text-right:before {
  position: absolute;
  content: "";
  border: 10px solid transparent;
  top: 15px;
  left: -20px;
}
.kaiwa-text-right:after {
  position: absolute;
  content: "";
  border: 10px solid transparent;
  border-right: 10px solid lightgray;
  top: 15px;
  left: -19px;
}
/* 右の三角形を作る */
.kaiwa-text-left:before {
  position: absolute;
  content: "";
  border: 10px solid transparent;
  top: 15px;
  right: -20px;
}
.kaiwa-text-left:after {
  position: absolute;
  content: "";
  border: 10px solid transparent;
  border-left: 10px solid lightgreen;
  top: 15px;
  right: -19px;
}
/* 回り込み解除 */
.kaiwa:after,
.kaiwa:before {
  clear: both;
  content: "";
  display: block;
}
</style>
