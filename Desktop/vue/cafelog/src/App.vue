<template>
  <div>
    <!-- eslint-disable  -->
    <div class="header">
      <div class="drower-container">
        <div class="humberger-container">
          <div id="humberger" @click="drawer = true">
            <div></div>
            <div></div>
            <div></div>
          </div>
        </div>

        <el-drawer :visible.sync="drawer" :direction="direction">
          <div class="link-container">
            <p>
              <router-link to="/posts">HomePage</router-link>
            </p>
            <p v-if="isAuthenticated" class="logout" v-on:click="logout">LogOut</p>
            <p class="logout" v-else v-on:click="login">LogIn</p>
            <p>
              <router-link :to="`/users/${userId}`" v-if="isAuthenticated">MyPage</router-link>
            </p>
            <!-- <p>
              <router-link to="/channels" v-if="isAuthenticated"
                >Chat Room</router-link
              >
            </p>-->
            <div>
              <router-link to="/search" class="myPage">Search</router-link>
            </div>
            <p class="logout" @click="openModal" v-if="isAuthenticated">Post</p>
            <transition name="my-modal">
              <div class="my-modal" v-if="modal">
                <div class="form-container">
                  <el-input type="text" v-model="cafename" placeholder="お店の名前" />
                  <el-input type="text" v-model="station" placeholder="最寄駅" />
                  <el-input type="text" v-model="address" placeholder="住所" />
                  <el-input type="text" v-model="tel" placeholder="電話番号" />
                  <el-checkbox v-model="wifi">wi-fiあり</el-checkbox>
                  <el-checkbox v-model="wifiless">wi-fiなし</el-checkbox>

                  <el-input type="text" v-model="content" placeholder="感想" />
                  <el-input type="text" v-model="holiday" placeholder="定休日" />
                  <el-checkbox v-model="open">開店</el-checkbox>
                  <el-checkbox v-model="close">閉店</el-checkbox>

                  <div id="image-container">
                    <div v-if="!image">
                      <input type="file" @change="onFileChange" />
                    </div>
                    <div v-else>
                      <img :src="image" class="postedImage" />
                      <el-button @click="removeImage">Remove</el-button>
                    </div>
                  </div>
                  <el-button @click="addPosts">Post</el-button>
                  <p @click="closeModal" class="my-modal-close">close</p>
                </div>
              </div>
            </transition>
          </div>
        </el-drawer>
      </div>
    </div>
    <!-- ここからがPCで見る画面 -->
    <div class="app-layout">
      <div class="sidebar">
        <!-- <div class="logo-container">
          <div class="logo">
            <img src="@/assets/station-market.png" />
          </div>
        </div>
        練習用のchatroomです。消さないでね。-->
        <!--eslint-disable-->
        <!-- <p v-for="(channel, index) in channels" :key="index">
          <router-link :to="`/channels/${channel.id}`">
            {{
            channel.name
            }}
          </router-link>
        </p>
        <hr />-->
        <div class="link-container">
          <div>
            <router-link to="/posts" class="el-icon-s-home">HomePage</router-link>
          </div>
          <a v-if="isAuthenticated" class="el-icon-s-tools" v-on:click="logout">LogOut</a>
          <a class="el-icon-s-tools" v-else v-on:click="login">LogIn</a>
          <div>
            <router-link
              :to="`/users/${userId}`"
              v-if="isAuthenticated"
              class="el-icon-user-solid"
            >MyPage</router-link>
          </div>
          <!-- <div>
            <router-link to="/channels" v-if="isAuthenticated" class="myPage"
              >ChatRoom</router-link
            >
          </div>-->
          <div>
            <router-link to="/search" class="el-icon-search">Search</router-link>
          </div>
          <a class="el-icon-s-promotion" @click="openModal" v-if="isAuthenticated">Post</a>
          <transition name="my-modal">
            <div class="my-modal" v-if="modal">
              <div class="form-container">
                <i type="primary" class="el-icon-close modalClose" 　@click="closeModal"></i>
                <el-input type="text" v-model="cafename" placeholder="お店の名前" class="form-block" />
                <el-input type="text" v-model="station" placeholder="最寄駅" class="form-block" />
                <el-input type="text" v-model="address" placeholder="住所" class="form-block" />
                <el-input type="text" v-model="tel" placeholder="電話番号" class="form-block" />
                <el-checkbox v-model="wifi" class="form-block">wi-fiあり</el-checkbox>
                <el-checkbox v-model="wifiless" class="form-block">wi-fiなし</el-checkbox>

                <el-input type="text" v-model="content" placeholder="感想" class="form-block" />
                <el-input type="text" v-model="holiday" placeholder="定休日" class="form-block" />
                <el-checkbox v-model="open" class="form-block">開店</el-checkbox>
                <el-checkbox v-model="close" class="form-block">閉店</el-checkbox>

                <div id="image-container">
                  <div v-if="!image">
                    <input type="file" @change="onFileChange" class="form-block" />
                  </div>
                  <div v-else>
                    <img :src="image" class="postedImage" />
                    <el-button @click="removeImage">Remove</el-button>
                  </div>
                </div>
                <el-button @click="addPosts" class="form-block">Post</el-button>
              </div>
            </div>
          </transition>
        </div>
      </div>
      <div class="main-content">
        <router-view :key="$route.fullPath" />
      </div>
    </div>
  </div>
</template>

<script>
import { db, firebase } from "@/firebase";
import { mapActions } from "vuex";
export default {
  data() {
    return {
      channels: [],
      cafename: "",
      content: "",
      holiday: "",
      station: "",
      address: "",
      tel: "",
      wifiless: false,
      wifi: false,
      open: false,
      close: false,
      file: "",
      image: "",
      modal: false,
      drawer: false,
      direction: "ltr"
    };
  },
  mounted() {
    db.collection("channels")
      .where("cafename", "==", "test")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.channels.push({ id: doc.id, ...doc.data() });
          console.log(doc.data().id);
        });
      });
    firebase.auth().onAuthStateChanged(user => {
      if (user) {
        this.setUser(user);
      }
    });
  },

  methods: {
    ...mapActions(["setUser"]),
    logout() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.setUser(null);
          window.alert("ログアウトに成功しました");
        })
        .catch(e => {
          window.alert("ログアウトに失敗しました");
          console.log(e);
        });
    },
    login() {
      const provider = new firebase.auth.GoogleAuthProvider();
      firebase
        .auth()
        .signInWithPopup(provider)
        .then(result => {
          db.collection("users").add({
            id: result.user.uid,
            name: result.user.displayName,
            thumbnail: result.user.photoURL,
            email: result.user.email
          });
          const user = result.user;
          console.log(provider);
          this.setUser(user);
          console.log(result); //resultの中にログインuser情報を保持している。多分引数だからresult関係なしに持ってこれる奴や
          console.log(this.$store.state.user);
          console.log(user);
          this.dialogVisible = false;
        })
        .catch(error => {
          window.alert(error);
        });
    },

    openModal() {
      this.modal = true;
    },
    closeModal() {
      this.modal = false;
    },
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
    addPosts() {
      let storageRef = firebase
        .storage()
        .ref(`posts/${this.user.displayName}/` + this.file.name);
      storageRef.put(this.file).then(() => {
        let storageRef = firebase
          .storage()
          .ref(`posts/${this.user.displayName}/` + this.file.name);
        storageRef.getDownloadURL().then(url => {
          //getDownloadURLメソッドでstorageから取得している;
          console.log(url);
          console.log(this.image);
          this.url = url;
          //このurlはfirebaseからの画像情報になる;
          window.alert("storageに格納しました");
          db.collection("posts").add({
            cafename: this.cafename,
            content: this.content,
            holiday: this.holiday,
            station: this.station,
            address: this.address,
            tel: this.tel,
            wifiless: this.wifiless,
            wifi: this.wifi,

            open: this.open,
            close: this.close,
            image: this.url,
            createdAt: new Date().getTime(),
            user: {
              id: this.user.uid,
              name: this.user.displayName,
              thumbnail: this.user.photoURL
            }
          });
        });
        console.log(this.url);
        window.alert("firestoreに格納しました。これで表示されます");
      });
      this.image = null;
    }
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.isAuthenticated;
    },
    userId() {
      return this.$store.state.user.uid;
    },
    user() {
      return this.$store.state.user;
    }
  }
};
</script>

<style>
/* .logo-container {
  width: 100%;
  height: auto;
}
.logo {
  width: 70%;
  margin: 0 auto;
}
.logo img {
  width: 100%;
  height: auto;
  border-radius: 15px;
} */

/* .app-layout {
  display: flex;
} */

.link-container {
  text-align: justify;
  display: flex;
}

.sidebar {
  background: #4a4141;
  height: auto;
  padding: 20px;
}
.sidebar a {
  color: white;
  padding-top: 4px;
  text-decoration: none;
  cursor: pointer;
  margin-left: 20px;
}

.main-content {
  width: 100%;
  /* この背景色が絶妙で良い */
  background: #f1f1f1;
  height: auto;
}

.postedImage {
  width: 100px;
  height: auto;
}
/* modalの要素 */
.my-modal-enter-active,
.my-modal-leave-active {
  transform: translate(0px, 0px);
  transition: transform 250ms cubic-bezier(0, 0, 0.2, 1) 0ms;
}
.my-modal-enter,
.my-modal-leave-to {
  transform: translateX(100vw) translateX(0px);
}
.my-modal {
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 100;
  width: 100vw;
  height: 100vh;
}
.form-container {
  width: 65%;
  height: auto;
  margin: 0 auto;
  background-color: white;
  padding: 30px;
}
.form-block {
  margin: 3px;
}
.drower-container {
  display: none;
}

@media screen and (max-width: 479px) {
  .sidebar {
    display: none;
  }
  .drower-container {
    display: block;
  }
  .link-container {
    color: #4a4141;
    text-decoration: none;
    text-align: center;
  }
  .logout {
    cursor: pointer;
    color: #4a4141;
  }
  .sidebar a {
    color: #4a4141;
    padding-top: 4px;
    text-decoration: none;
    cursor: pointer;
  }
  .header {
    width: 100%;
    height: 50px;
    background-color: #4a4141;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  }
  /* ドロワーアイコンの要素 */
  #humberger {
    position: relative;
    height: 24px;
    width: 24px;
    display: inline-block;
    box-sizing: border-box;
  }
  #humberger div {
    position: absolute;
    left: 0;
    height: 4px;
    width: 24px;
    background-color: white;
    border-radius: 2px;
    display: inline-block;
    box-sizing: border-box;
  }
  #humberger div:nth-of-type(1) {
    top: 0;
  }
  #humberger div:nth-of-type(2) {
    top: 10px;
  }
  #humberger div:nth-of-type(3) {
    bottom: 0;
  }
  .humberger-container {
    width: 15%;
    text-align: center;
    padding-top: 12.5px;
  }
}
</style>
