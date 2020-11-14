<template>
  <!-- eslint-disable  -->
  <div class="wrap">
    <div class="header-container">
      <div class="sidebar">
        <div class="logo-container">
          <img src="./assets/logo.jpg" class="logo" />
        </div>
        <div class="link-container">
          <div>
            <router-link to="/posts" class="el-icon-house"
              >HomePage</router-link
            >
          </div>
          <a v-if="isAuthenticated" class="el-icon-setting" v-on:click="logout">LogOut</a>
          <a class="el-icon-s-tools" v-else v-on:click="login">LogIn</a>
          <div>
            <router-link
              :to="`/users/${userId}`"
              v-if="isAuthenticated"
              class="el-icon-user"
              >MyPage</router-link
            >
          </div>
          <div>
            <router-link to="/search" class="el-icon-search"
              >Search</router-link
            >
          </div>
          <a class="el-icon-position" @click="openModal" v-if="isAuthenticated"
            >Post</a
          >
          <transition name="my-modal">
            <div class="my-modal" v-if="modal">
              <div class="form-container">
                <i
                  type="primary"
                  class="el-icon-close modalClose"
                  　@click="closeModal"
                ></i>
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
                <el-checkbox-button v-model="wifi" class="form-block"
                  >wi-fiあり</el-checkbox-button
                >
                <el-checkbox-button v-model="nearplace" class="form-block"
                  >駅から近い</el-checkbox-button
                >
                <el-checkbox-button v-model="date" class="form-block"
                  >デートにおすすめ</el-checkbox-button
                >
                <el-checkbox-button v-model="studying" class="form-block"
                  >勉強しやすい</el-checkbox-button
                >
                <star-rating
                  v-model="rating"
                  v-bind:increment="1"
                  v-bind:max-rating="5"
                  inactive-color="#9e9e9e"
                  active-color="#E6E635"
                  v-bind:star-size="30"
                  @rating-selected="setRating"
                ></star-rating>
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
                <el-checkbox v-model="open" class="form-block"
                  >開店</el-checkbox
                >
                <el-checkbox v-model="close" class="form-block"
                  >閉店</el-checkbox
                >

                <div id="image-container">
                  <div v-if="!image">
                    <input
                      type="file"
                      @change="onFileChange"
                      class="form-block"
                    />
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
    </div>
    <div class="main-content">
      <router-view :key="$route.fullPath" />
    </div>
    <div class="responsive-footer">
      <div class="link-block"><router-link to="/posts"><div class="el-icon-house"></div><div>Home</div></router-link></div>
      <div class="link-block"><router-link to="/search"><div class="el-icon-search"></div><div>Search</div></router-link></div>
      <div class="link-block" v-if="isAuthenticated"><router-link :to="`/users/${userId}`" ><div class="el-icon-user"></div><div>User</div></router-link></div>
      <div class="link-block" v-else><a v-on:click="login"><div class="el-icon-s-tools"></div><div>LogIn</div> </a></div>
    </div>
  </div>
</template>

<script>
import { db, firebase } from "@/firebase";
import { mapActions } from "vuex";
import StarRating from "vue-star-rating";
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
      wifi: false,
      nearplace: false,
      date: false,
      studying: false,
      open: false,
      close: false,
      file: "",
      image: "",
      modal: false,
      drawer: false,
      direction: "ltr",
      rating: ""
    };
  },
  components: {
    StarRating
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
            wifi: this.wifi,
            nearplace: this.nearplace,
            date: this.date,
            studying: this.studying,
            rating: this.rating,
            beliked: false,
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
/* scopeを外してアスタリスクで指定すると余白が消える */
*{
margin:0;
padding:0;
}
.wrap {
     overflow: hidden;
 }
.header-container {
  width: 100%;
  display: flex;
}
.sidebar {
  width: 100%;
  background: #f1f1f1;
  padding: 8px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  display: flex;
}

.link-container {
  width: 50%;
  /* background-color: aquamarine; */
  margin: 0 0 0 auto;
  /* 右に寄せる */
  display: flex;
}
.sidebar a {
  color: #4a4141;
  padding-top: 15px;
  text-decoration: none;
  justify-content: center;
  cursor: pointer;
  margin-left: 35px;
  font-weight: bold;
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
  margin-left: 30px;
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
.responsive-footer{
  display: none;
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
  .link-block{
    padding: 5px 40px;
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
}
</style>
