<template>
  <!-- eslint-disable  -->
  <div class="wrap">
    <div class="header-container">
      <div class="sidebar">
        <div class="logo-container">
          <img src="./assets/logo.jpg" class="logo" />
        </div>
        <div class="link-container">
          <router-link to="/posts"
            ><font-awesome-icon icon="home" 　class="font-awesome-adjustment" />
            <div>Home</div>
          </router-link>
          <a v-if="isAuthenticated" v-on:click="logout"
            ><font-awesome-icon
              icon="sign-out-alt"
              class="font-awesome-adjustment"
            />LogOut</a
          >

          <a @click="login" v-if="!isAuthenticated"
            ><font-awesome-icon
              icon="sign-in-alt"
              class="font-awesome-adjustment"
            />LogIn</a
          >
          <a @click="anonymouse" v-if="!isAuthenticated"
            ><font-awesome-icon
              icon="user-secret"
              class="font-awesome-adjustment"
            />GuestLogin</a
          >

          <router-link :to="`/users/${userId}`" v-if="isAuthenticated"
            ><font-awesome-icon
              icon="user"
              class="font-awesome-adjustment"
            />MyPage</router-link
          >

          <router-link to="/search"
            ><font-awesome-icon
              icon="search"
              class="font-awesome-adjustment"
            />Search</router-link
          >

          <a @click="openModal" v-if="isAuthenticated"
            ><font-awesome-icon
              icon="paper-plane"
              class="font-awesome-adjustment"
            />Post</a
          >

          <transition name="my-modal">
            <div class="my-modal" v-if="modal">
              <div class="form-container">
                <i
                  type="primary"
                  class="el-icon-close modal-close"
                  　@click="closeModal"
                ></i>
                <!-- ここからコンポーネントで使う -->
                <el-input
                  type="text"
                  v-model="cafename"
                  placeholder="お店の名前"
                  class="form-block"
                />
                <el-input
                  type="text"
                  v-model="station"
                  placeholder="最寄駅"
                  class="form-block"
                />
                <el-input
                  type="text"
                  v-model="address"
                  placeholder="住所"
                  class="form-block"
                />
                <el-input
                  type="text"
                  v-model="tel"
                  placeholder="電話番号"
                  class="form-block"
                />
                <div class="form-block">
                  <!-- divで囲まないと中途半端なレイアウトになる -->
                  <el-checkbox-button v-model="wifi"
                    >wi-fiあり</el-checkbox-button
                  >
                  <el-checkbox-button v-model="date"
                    >デートにお勧め</el-checkbox-button
                  >
                  <el-checkbox-button v-model="studying"
                    >勉強しやすい</el-checkbox-button
                  >
                  <el-checkbox-button v-model="goodcoffee"
                    >こだわりコーヒー</el-checkbox-button
                  >
                  <el-checkbox-button v-model="coffeestand"
                    >コーヒースタンド</el-checkbox-button
                  >
                  <el-checkbox-button v-model="stayalone"
                    >一人で過ごしやすい</el-checkbox-button
                  >
                </div>
                <div class="form-block">
                  <star-rating
                    v-model="rating"
                    v-bind:increment="1"
                    v-bind:max-rating="5"
                    inactive-color="#9e9e9e"
                    active-color="#E6E635"
                    v-bind:star-size="30"
                    @rating-selected="setRating"
                  ></star-rating>
                </div>
                <el-input
                  type="text"
                  v-model="content"
                  placeholder="感想"
                  class="form-block"
                />
                <el-input
                  type="text"
                  v-model="holiday"
                  placeholder="定休日"
                  class="form-block"
                />
                <div class="form-block">
                  <el-checkbox-button v-model="open">開店</el-checkbox-button>
                  <el-checkbox-button v-model="close">閉店</el-checkbox-button>
                </div>
                <el-input
                  type="text"
                  v-model.number="lat"
                  placeholder="緯度"
                  class="form-block"
                />
                <el-input
                  type="text"
                  v-model.number="lng"
                  placeholder="経度"
                  class="form-block"
                />
                <div id="image-container">
                  <div v-if="!image">
                    <input
                      type="file"
                      @change="onFileChange"
                      class="form-block"
                    />
                  </div>
                  <div v-else>
                    <div class="form-block">
                      <img :src="image" class="postedImage" />
                      <el-button @click="removeImage">Remove</el-button>
                    </div>
                  </div>
                </div>
                <!-- ここまでコンポーネントで切り離す -->
                <div class="form-block">
                  <el-button @click="addPosts" class="form-block"
                    >POST</el-button
                  >
                </div>
              </div>
            </div>
          </transition>
        </div>
      </div>
    </div>
    <div class="main-content">
      <router-view :key="$route.fullPath" />
      <!-- :keyを指定することで強制レンダリングをさせている。 -->
    </div>
    <div class="responsive-footer">
      <div class="link-block">
        <router-link to="/posts"
          ><font-awesome-icon icon="home" />
          <div>Home</div></router-link
        >
      </div>
      <div class="link-block">
        <router-link to="/search"
          ><font-awesome-icon icon="search" />
          <div>Search</div></router-link
        >
      </div>
      <div class="link-block" v-if="isAuthenticated">
        <router-link :to="`/users/${userId}`"
          ><font-awesome-icon icon="user" />
          <div>User</div></router-link
        >
      </div>
      <div class="link-block" v-if="!isAuthenticated">
        <a v-on:click="login"
          ><font-awesome-icon icon="sign-in-alt" />
          <div>LogIn</div>
        </a>
      </div>
      <div class="link-block" v-if="!isAuthenticated">
        <a @click="anonymouse"
          ><font-awesome-icon icon="user-secret" />
          <div>Guest</div></a
        >
      </div>
    </div>
    <footer>
      　　
      <ul class="footer-menu">
        <li><router-link to="/">Home</router-link> ｜</li>
        <li>Login ｜</li>
        <li>GuestLogin ｜</li>
        <li>Search ｜</li>
        <li>
          <router-link to="Contact">Contact</router-link>
        </li>
      </ul>
      <p>© All rights reserved by cafelog.</p>
    </footer>
  </div>
</template>

<script>
import { db, firebase } from "@/firebase";
import { mapActions } from "vuex";
import StarRating from "vue-star-rating";
export default {
  data() {
    return {
      //channels: [],
      cafename: "",
      content: "",
      holiday: "",
      station: "",
      address: "",
      tel: "",
      rating: "",
      wifi: false,
      date: false,
      studying: false,
      goodcoffee: false,
      coffeestand: false,
      stayalone: false,
      open: false,
      close: false,
      file: "",
      image: "",
      modal: false,
      drawer: false,
      direction: "ltr",
      lat: "",
      lng: ""
    };
  },
  components: {
    StarRating
  },
  mounted() {
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
          //ここでゲストログインをユーザは痕跡を全て消す。
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
    //匿名ログインの設定
    anonymouse: function() {
      firebase
        .auth()
        .signInAnonymously()
        .then(() => {
          alert("ゲストログインしています。");
        })
        .catch(function(error) {
          alert(error.message);
        });
    },
    setRating: function(rating) {
      this.rating = rating;
      console.log(this.rating);
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
      reader.onload = function (event) {
        vm.image = event.target.result;
        //これもthis.imageだよ！
        //vm.imageが投稿前の画像表示の中身になる
        console.log(vm.image);
      };
      reader.readAsDataURL(file);
      console.log(file);
      console.log(vm);
      console.log(vm.image);
      this.file = file;
    },
    removeImage: function () {
      this.image = "";
    },
    addPosts() {
      let storageRef = firebase
        .storage()
        .ref(`posts/${this.user.displayName}/` + this.file.name);
      storageRef
        .put(this.file)
        .then(() => {
          let storageRef = firebase
            .storage()
            .ref(`posts/${this.user.displayName}/` + this.file.name);
          storageRef.getDownloadURL().then((url) => {
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
              wifi: this.wifi,
              date: this.date,
              studying: this.studying,
              goodcoffee: this.goodcoffee,
              coffeestand: this.coffeestand,
              stayalone: this.stayalone,
              rating: this.rating,
              open: this.open,
              close: this.close,
              lat: this.lat,
              lng: this.lng,
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
          window.alert("firestoreに格納しました。これで表示されます");
        })
        .then(() => {
          this.modal = false;
        });
    },
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
    },
  },
};
</script>

<style>
/* scopeを外してアスタリスクで指定すると余白が消える */
* {
  margin: 0;
  padding: 0;
}

.wrap {
  /* overflow: hidden;   */
}
.header-container {
  display: flex;
  max-width: 100%;
  background: #f1f1f1;
}
.sidebar {
  width: 100%;
  padding: 10px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  display: flex;
}

.link-container {
  max-width: 100%;
  /* background-color: aquamarine; */
  /* margin: 0 0 0 auto; */
  /* 右に寄せる */
  display: flex;
  padding: 0 50px 0 0;
}
.sidebar a {
  color: #4a4141;
  padding-top: 15px;
  text-decoration: none;
  justify-content: center;
  cursor: pointer;
  margin-left: 35px;
  font-weight: bold;
  display: flex;
}
.logo-container {
  width: 50%;
  height: 50px;
  /* background-color: khaki; */
}
.logo {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 50%;
  margin-left: 50px;
}

.main-content {
  width: 100%;
  /* この背景色が絶妙で良い */
  background: #f1f1f1;
  height: auto;
}

.postedImage {
  width: 150px;
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
  width: 80%;
  height: auto;
  padding: 3% 2%;
  background-color: white;
}
.form-container .form-block {
  margin: 3px;
}
.drower-container {
  display: none;
}
.responsive-footer {
  display: none;
}
.modal-close {
  /* モーダルを閉じる×印を右端に寄せる */
  width: 100%;
  text-align: end;
}
.font-awesome-adjustment {
  margin: 3px 2px 0 0;
}
footer {
  max-width: 100%;
  /* これで無駄な横は見出しを防ぐことができる */
  height: 50px;
  background-color: white;
  color: #4a4141;
  text-align: center;
  padding: 20px;
}
ul.footer-menu li {
  display: inline;
  padding: 10px 5px;
}

@media screen and (max-width: 479px) {
  .sidebar {
    display: none;
  }
  .main-content {
    width: 100%;
    /* この背景色が絶妙で良い */
    background: #f1f1f1;
    height: auto;
  }
  .responsive-footer {
    display: block;
    position: fixed;
    bottom: 0;
    width: 100%;
    background-color: #f1f1f1;
    z-index: 9999;
    height: auto;
    box-shadow: 0 1px 8px rgba(0, 0, 0, 0.16), 0 1px 8px rgba(0, 0, 0, 0.23);
    /* 横並びにして等間隔に並べる要素 */
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: space-between;
  }
  .link-block {
    padding: 5px 25px;
    display: flex;
    text-align: center;
  }
  .link-block a {
    color: black;
    text-decoration: none;
    justify-content: center;
    cursor: pointer;
    font-weight: bold;
  }
  footer {
    display: none;
  }
}
</style>
