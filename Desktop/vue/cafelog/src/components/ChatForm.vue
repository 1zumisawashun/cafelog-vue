<template>
  <div class="input-container">
    <img v-if="isAuthenticated" :src="user.photoURL" class="avatar" />
    <!--eslint-disable-->
    <textarea
      class="textarea-container"
      v-model="text"
      v-if="isAuthenticated"
      v-on:keydown.enter="addMessage"
    />
    <textarea
      class="textarea-container"
      v-model="text"
      v-else
      v-on:click="openLoginModal"
    />
    <div id="image-container">
      <div v-if="!image">
        <input type="file" @change="onFileChange" class="file-container" />
      </div>
      <div v-else>
        <img :src="image" class="image" />
        <button @click="removeImage">Remove</button>
      </div>
    </div>
    <el-dialog title :visible.sync="dialogVisible" width="30%">
      <div class="image-container">
        <!-- <img src="@/assets/google_sign_in.png" @click="login" /> -->
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { db, firebase } from "@/firebase";
import Vue from "vue";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
Vue.use(ElementUI);
import { mapActions } from "vuex";

export default {
  methods: {
    ...mapActions(["setUser"]), //これがdispatchに当たる省略記法
    onFileChange: function(event) {
      var files = event.target.files || event.dataTransfer.files;
      if (!files.length) {
        return;
      }
      this.createImage(files[0]);
    },
    createImage(file) {
      /*eslint-disable*/
      var image = new Image();
      var reader = new FileReader();
      var vm = this;
      reader.onload = function(event) {
        vm.image = event.target.result;
        //これもthis.imageだよ！
        console.log(vm.image);
      };
      reader.readAsDataURL(file);
      console.log(file);
      console.log(vm.image);
      this.file = file;
    },
    removeImage: function() {
      this.image = "";
    },
    addMessage(event) {
      if (this.keyDownedForJPComversion(event)) {
        return;
      }
      console.log(this.file);
      if (this.file) {
        let storageRef = firebase
          .storage()
          .ref(`images/${this.user.displayName}/` + this.file.name);
        storageRef.put(this.file).then(() => {
          let storageRef = firebase
            .storage()
            .ref(`images/${this.user.displayName}/` + this.file.name);
          storageRef.getDownloadURL().then((url) => {
            //getDownloadURLメソッドでstorageから取得している
            console.log(url);
            console.log(this.image);
            this.url = url;
            //このurlはfirebaseからの画像情報になる
            window.alert("storageに格納しました");
            const channelId = this.$route.params.id;
            db.collection("channels")
              .doc(channelId)
              .collection("messages")
              .add({
                text: this.text,
                image: this.url,
                createdAt: new Date().getTime(),
                user: {
                  id: this.user.uid,
                  name: this.user.displayName,
                  thumbnail: this.user.photoURL,
                },
              });
          });
          console.log(this.url);
          window.alert("firestoreに格納しました");
        });
        this.image = null;
      } else {
        const channelId = this.$route.params.id;
        db.collection("channels")
          .doc(channelId)
          .collection("messages")
          .add({
            text: this.text,
            createdAt: new Date().getTime(),
            user: {
              id: this.user.uid,
              name: this.user.displayName,
              thumbnail: this.user.photoURL,
            },
          });
        window.alert("テキストを出力します");
      }
    },

    keyDownedForJPComversion(event) {
      const codeForConversion = 229;
      return event.keyCode === codeForConversion;
    },
    openLoginModal() {
      this.dialogVisible = true;
    },
    login() {
      const provider = new firebase.auth.GoogleAuthProvider();
      firebase
        .auth()
        .signInWithPopup(provider)
        .then((result) => {
          db.collection("users").add({
            id: result.user.uid,
            name: result.user.displayName,
            thumbnail: result.user.photoURL,
            email: result.user.email,
          });
          const user = result.user;
          console.log(provider);
          this.setUser(user);
          console.log(result); //resultの中にログインuser情報を保持している。多分引数だからresult関係なしに持ってこれる奴や
          console.log(this.$store.state.user);
          console.log(user);
          this.dialogVisible = false;
        })
        .catch((error) => {
          window.alert(error);
        });
    },
  },
  data() {
    return {
      dialogVisible: false,
      text: null,
      image: "", //event.target.result→すごく長い文字列が格納されている
      file: "", //写真の情報が格納されている
      url: null, //storageの情報が格納されている
    };
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.isAuthenticated;
    },
    user() {
      return this.$store.state.user;
    },
  },
};
</script>

<style scoped>
.input-container {
  padding: 10px;
  height: 100%;
  display: flex;
  flex-wrap: wrap;
}
.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
}

.textarea-container {
  width: 95%;
  height: 100%;
}
.file-container {
  width: 100%;
}
.image-container {
  display: flex;
  justify-content: center;
}

img {
  width: 70%;
  cursor: pointer;
}
.image {
  width: 100px;
  height: 100px;
}
</style>
