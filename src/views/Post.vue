<template>
  <div class="flex" id="main-content">
    <!-- eslint-disable  -->
    <div class="post-container">
      <div class="post-block">
        <div v-for="(post, index) in post" :key="index">
          <div class="post-info">
            <img :src="post.image" class="image shadow" />
            <div class="content-block">
              <h3>投稿者のコメント</h3>
              <hr />
              <p>{{ post.content }}</p>
            </div>
          </div>
          <div style="margin: 10px">
            <div class="cafename">{{ post.cafename }}</div>

            <div class="beLiked" v-show="isNotLoginUser">
              <font-awesome-icon
                class="save-container dislike"
                icon="heart"
                v-if="beLiked"
                @click="unlikes()"
              />
              <font-awesome-icon
                class="save-container like"
                icon="heart"
                v-else
                @click="likes()"
              />
              <div class="likecount">
              {{ likeCount }}
              </div>
              <el-button class="open shadow" size="small" v-show="post.open"
                >開店</el-button
              >
              <el-button
                class="close shadow"
                size="small"
                v-show="post.close"
                type="danger"
                >閉店</el-button
              >
              <el-button
                type="danger"
                class="shadow"
                size="small"
                @click="deleteButton(post)"
                v-show="isPosted"
                >DELETE</el-button
              >
              <el-button
                type="primary"
                class="shadow"
                size="small"
                @click="openUpdateModal"
                v-show="isPosted"
                >UPDATE</el-button
              >
              <el-dialog
                cafename
                :visible.sync="UpdateDialogVisible"
                width="80%"
              >
                <div class="update-form-container">
                  <post-form
                    :post="post"
                    @update="updateButton(post)"
                  ></post-form>
                </div>
              </el-dialog>
            </div>

            <hr />
            <div class="resposive-comment-container">
              <img :src="post.user.thumbnail" alt class="user-thumbnail" />
              <div class="comment-block">
                <div class="comment-content">{{ post.content }}</div>
              </div>
            </div>
            <div class="not-resposive-comment-container">
              <img :src="post.user.thumbnail" alt class="user-thumbnail" />
              <div class="comment-block">
                <div class="comment-content">{{ post.content }}</div>
              </div>
            </div>
            <div v-for="(comment, index) in comments" :key="index">
              <div class="comment-container">
                <img :src="comment.thumbnail" alt class="user-thumbnail" />
                <div class="comment-block">
                  <div class="comment-content">{{ comment.comment }}</div>
                </div>
              </div>
            </div>
            <el-button
              type="primary"
              class="shadow"
              size="small"
              @click="openCommentModal"
              >コメント</el-button
            >
            <el-dialog cafename :visible.sync="CommentDialogVisible">
              <div>コメントを記入してください。</div>
              <el-input type="text" v-model="comment" />
              <el-button @click="addComment(post.id)" size="small"
                >コメントする</el-button
              >
            </el-dialog>

            <hr />

            <div id="image-container">
              <div
                v-for="(image, index) in images"
                :key="index"
                class="image-block"
              >
                <img :src="image.image" class="picture" alt />
              </div>
            </div>
            <el-button
              type="primary"
              class="shadow"
              size="small"
              @click="openImageModal"
              >写真</el-button
            >

            <el-dialog cafename :visible.sync="ImageDialogVisible">
              <p>写真を投稿してください。</p>
              <div class="image-container">
                <div v-if="!image">
                  <input
                    type="file"
                    @change="onFileChange"
                    class="file-container"
                  />
                </div>
                <div v-else>
                  <img :src="image" class="image" />
                  <el-button @click="removeImage">Remove</el-button>
                  <el-button @click="addImage()" size="small">post</el-button>
                </div>
              </div>
            </el-dialog>

            <hr />
          </div>
          <!-- ↑margin10pxの締めdiv -->
          <table>
            <tr>
              <th>最寄駅</th>
              <td>{{ post.station }}駅</td>
            </tr>
            <tr>
              <th>住所</th>
              <td>{{ post.address }}</td>
            </tr>
            <tr>
              <th>定休日</th>
              <td>{{ post.holiday }}</td>
            </tr>
            <tr>
              <th>電話番号</th>
              <td>{{ post.tel }}</td>
            </tr>
          </table>
          <GmapMap
            :center="{ lng: post.lng, lat: post.lat }"
            :zoom="15"
            map-type-id="roadmap"
            class="map-block shadow"
          >
            <GmapMarker
              :key="index"
              v-for="(m, index) in markers"
              :position="{ lng: post.lng, lat: post.lat }"
              :clickable="true"
              :draggable="true"
              @click="center = { lng: post.lng, lat: post.lat }"
            />
          </GmapMap>
        </div>
      </div>
    </div>
    <div class="side-menu">
      <div class="side-menu-title">
        おすすめカフェ
      </div>
      <div v-for="(recommend, index) in this.recommends" :key="index">
        <div class="side-menu-content " >
          <img :src="recommend.image" class="side-menu-image shadow" />
          <div class="side-menu-cafename">{{ recommend.cafename }}</div>
          <div class="side-menu-station">{{ recommend.station }}駅</div>
        </div>
      </div>
      <div class="side-menu-title">
        閲覧履歴
      </div>
      <div v-for="(footprint, index) in this.footprints" :key="index">
        <div class="side-menu-content" >
          <img :src="footprint.image" class="side-menu-image shadow" />
          <div class="side-menu-cafename">{{ footprint.cafename }}</div>
          <div class="side-menu-station">{{ footprint.station }}駅</div>
        </div>
      </div>
    </div>
  </div>
  
</template>

<script>
import { db, firebase } from "@/firebase";
import PostForm from "@/components/PostForm.vue";
export default {
  data() {
    return {
      post: [],
      //postをばらしてデータの中に入れればpostFormとして再利用できそう。
      CommentDialogVisible: false,
      UpdateDialogVisible: false,
      ImageDialogVisible: false,
      updateContent: "",
      eraseElement: false,
      eraseChat: true,
      comments: [],
      comment: "",
      images: [],
      image: "", //event.target.result→すごく長い文字列が格納されている
      file: [], //写真の情報が格納されている
      url: null, //storageの情報が格納されている
      beLiked: false,
      likeCount: 0,
      commentCount: 0,
      isPosted: false,
      isNotLoginUser: true,
      markers: [{ position: { lng: 10.5, lat: 10 } }],
      recommends: [],
      footprints: []
    };
  },
  components: {
    PostForm
  },
  computed: {
    userId() {
      return this.$store.state.user.uid;
    },
    user() {
      return this.$store.state.user;
    },
    isAuthenticated() {
      return this.$store.getters.isAuthenticated;
    }
  },
  mounted() {
    //いいねを付ける、取り外しをする----------------------------------------------
    const postId = this.$route.params.id;
    if (this.user === null) {
      this.isNotLoginUser = false;
    } else {
      const userid = this.userId; //よくわからないがuseridを再度定義しないとエラーになる為記載
      db.collection("posts")
        .doc(postId)
        .collection("likes")
        .where("currentUser", "==", userid)
        .get()
        .then(doc => {
          if (doc.docs.length === 1) {
            this.beLiked = true;
            console.log(this.beLiked);
          } else {
            this.beLiked = false;
            console.log(this.beLiked);
          }
          //existを使えばlengthで中身を検索しなくてもOK
        })
        .catch(function(error) {
          // いずれかのreadFileでエラーがあった場合の処理
          console.log(error);
          this.guestuser = false;
        });
    }
    //いいねをカウントする----------------------------------------------
    const likeRef = db
      .collection("posts")
      .doc(postId)
      .collection("likes");
    likeRef.onSnapshot(snap => {
      this.likeCount = snap.size;
    });

    //postの情報を取得する----------------------------------------------
    const postsId = this.$route.params.id;
    db.collection("posts")
      .doc(postsId)
      .get()
      .then(docSnapshot => {
        console.log(docSnapshot.data().user.id);
        console.log(docSnapshot.id);
        console.log(docSnapshot.get("content"));
        this.post.push({ id: docSnapshot.id, ...docSnapshot.data() });
        if (this.userId === docSnapshot.data().user.id) {
          this.eraseElement = true;
          this.eraseChat = false;
          this.isPosted = true;
          console.log(this.eraseElement);
        }
      });

    //修正したらリアルタイムで反映される----------------------------------------------
    db.collection("posts")
      .doc(postsId)
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          const doc = change.doc;
          if (change.type === "modified") {
            this.post.push({
              id: doc.id,
              ...doc.data()
            });
          }
        });
      });
    //コメント投稿機能----------------------------------------------
    db.collection("posts")
      .doc(postsId)
      .collection("comments")
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          const doc = change.doc;
          if (change.type === "added") {
            this.comments.push({
              id: doc.id,
              ...doc.data()
            });
          }
        });
      });

    //写真投稿機能----------------------------------------------
    db.collection("posts")
      .doc(postsId)
      .collection("images")
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          const doc = change.doc;
          if (change.type === "added") {
            this.images.push({
              id: doc.id,
              ...doc.data()
            });
          }
        });
      });
    //リコメンド機能----------------------------------------------
    const post = this.post;
    console.log(post);
    const osusume = [];
    db.collection("posts")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          if (post[0].station === doc.data().station) {
            osusume.push({ id: doc.id, ...doc.data() });
            console.log(post[0].cafename);
            //forEachで配列の外に出しているからdataは[]で準備しておかなくてはならない
            //mapメソッドを使用すれば問題ないと思う
          }
        });
      })
      .then(() => {
        //配列の中、インデックス番号0,1,2を取得してrecommendsに格納する。whereの代わりをしている感じ
        this.recommends = osusume.slice(0, 3);
        console.log(this.recommends);
      });
    console.log("緯度をテストしています");
    //ユーザーの足跡機能----------------------------------------------
    const obj = [];
    db.collection("posts")
      .doc(postsId)
      .get()
      .then(docSnapshot => {
        obj.push({
          cafename: docSnapshot.data().cafename,
          station: docSnapshot.data().station,
          image: docSnapshot.data().image
        });
      })
      .then(() => {
        var existingEntries = JSON.parse(localStorage.getItem("allEntries"));
        if (existingEntries == null) {
          existingEntries = [];
        }
        localStorage.setItem("entry", JSON.stringify(obj));
        if (existingEntries.length == 0) {
          existingEntries.push(obj);
          console.log("同じカフェが配列のないなら追加する");
        } else if (existingEntries.length == 1) {
          if (obj[0].cafename == existingEntries[0][0].cafename) {
            existingEntries.splice(0, 1);
            existingEntries.push(obj);
          } else {
            existingEntries.push(obj);
          }
        } else if (existingEntries.length == 2) {
          if (obj[0].cafename == existingEntries[0][0].cafename) {
            existingEntries.splice(0, 1);
            existingEntries.push(obj);
          } else if (obj[0].cafename == existingEntries[1][0].cafename) {
            existingEntries.splice(1, 1);
            existingEntries.push(obj);
          } else {
            existingEntries.push(obj);
          }
        } else if (existingEntries.length == 3) {
          if (obj[0].cafename == existingEntries[1][0].cafename) {
            existingEntries.splice(1, 1);
            existingEntries.push(obj);
            console.log("同じカフェが配列の２個目にあったら発火する");
          } else if (obj[0].cafename == existingEntries[2][0].cafename) {
            existingEntries.splice(2, 1);
            existingEntries.push(obj);
            console.log("同じカフェが配列の3個目にあったら発火する");
          } else {
            existingEntries.splice(0, 1);
            existingEntries.push(obj);
            console.log("同じカフェが配列の1個目にあったら発火する");
          }
        }
        localStorage.setItem("allEntries", JSON.stringify(existingEntries));
        return existingEntries;
        //ここでreturnで返り値を出す宣言をすることで、then以降に指定の変数を送ることができる
        //しかもreturnをした時点で変数が使えなくなるので、大体一番最後に書く
      })
      .then(existingEntries => {
        console.log(existingEntries);
        existingEntries.forEach(foot => {
          this.footprints.push(...foot);
        });
        console.log(this.footprints);
      });
  },
  methods: {
    openCommentModal() {
      if (this.user == null) {
        alert("ログインしてください。");
        this.login();
      } else {
        this.CommentDialogVisible = true;
      }
    },
    openImageModal() {
      if (this.user == null) {
        alert("ログインしてください。");
        this.login();
      } else {
        this.ImageDialogVisible = true;
      }
    },
    openUpdateModal() {
      this.UpdateDialogVisible = true;
    },
    updateButton(post) {
      //fileの中身もしっかりemitされている。
      console.log(post);
      alert("updateスタート");
      let storageRef = firebase
        .storage()
        .ref(`posts/${this.user.displayName}/` + post.file.name);
      //写真が更新されないと何も反応しなくなる。
      storageRef
        .put(post.file)
        .then(() => {
          alert("写真の格納をします。");
          let storageRef = firebase
            .storage()
            .ref(`posts/${this.user.displayName}/` + post.file.name);
          storageRef.getDownloadURL().then(url => {
            //urlが画像表示の肝になる
            db.collection("posts")
              .doc(post.id)
              .update({
                cafename: post.cafename,
                content: post.content,
                holiday: post.holiday,
                station: post.station,
                address: post.address,
                tel: post.tel,
                wifi: post.wifi,
                date: post.date,
                studying: post.studying,
                goodcoffee: post.goodcoffee,
                coffeestand: post.coffeestand,
                stayalone: post.stayalone,
                rating: post.rating,
                open: post.open,
                close: post.close,
                lat: post.lat,
                lng: post.lng,
                image: url,
                // post.urlにしない
                createdAt: new Date().getTime(),
                user: {
                  id: this.user.uid,
                  name: this.user.displayName,
                  thumbnail: this.user.photoURL
                }
              });
          });
        })
        .then(() => {
          alert("メッセージの更新に成功しました");
          console.log(this.post);
          console.log(post.image);
          console.log(this.post[0].cafename);
          console.log(post.id);
          this.UpdateDialogVisible = false;
        });
    },
    deleteButton(post) {
      db.collection("posts")
        .doc(post.id)
        .delete()
        .then(() => {
          alert("削除しました");
          this.$router.push("/");
        });
    },
    addComment(id) {
      console.log("コメントをテストしています");
      db.collection("posts")
        .doc(id)
        .collection("comments")
        .add({
          username: this.user.displayName,
          comment: this.comment,
          thumbnail: this.user.photoURL
        })
        .then(() => {
          alert("コメントの追加をしました");
          this.CommentDialogVisible = false;
          //this.$router.push(`/posts/${id}`);
        });
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
        console.log(vm.image);
      };
      reader.readAsDataURL(file);
      console.log(file);
      console.log(vm.image);
      this.file = file;
    },
    removeImage: function () {
      //this.image = ""; updateができない
      this.post[0].image = "";
    },
    addImage(event) {
      console.log("写真投稿のテスト");
      console.log(this.file);
      if (this.file) {
        let storageRef = firebase
          .storage()
          .ref(`images/${this.user.displayName}/` + this.file.name);
        storageRef.put(this.file).then(() => {
          let storageRef = firebase
            .storage()
            .ref(`images/${this.user.displayName}/` + this.file.name);
          storageRef
            .getDownloadURL()
            .then((url) => {
              //getDownloadURLメソッドでstorageから取得している
              console.log(url);
              console.log(this.image);
              this.url = url;
              //このurlはfirebaseからの画像情報になる
              window.alert("storageに格納しました");
              const channelId = this.$route.params.id;
              db.collection("posts")
                .doc(channelId)
                .collection("images")
                .add({
                  image: this.url,
                  createdAt: new Date().getTime(),
                  user: {
                    id: this.userId,
                    name: this.user.displayName,
                    thumbnail: this.user.photoURL,
                  },
                });
            })
            .then(() => {
              alert("コメントの追加をしました");
              this.ImageDialogVisible = false;
            });
        });
      }
    },
    likes() {
      const postId = this.$route.params.id;
      db.collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(this.userId)
        .set({
          //setはaddと違いしていたidにデータをいれることができる。
          //一番上に来るのがidに当てはめられる
          id: this.post[0].id,
          cafename: this.post[0].cafename,
          station: this.post[0].station,
          image: this.post[0].image,
          user: {
            id: this.post[0].user.id,
            name: this.post[0].user.name,
            thumbnail: this.post[0].user.thumbnail,
          },
          currentUser: this.user.uid,
        })
        .then(() => {
          db.collection("posts").doc(postId).update({
            beliked: true,
          });
        });
      this.beLiked = true;
      alert("いいねしました。");
    },
    unlikes() {
      const postId = this.$route.params.id;
      db.collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(this.userId)
        .delete()
        .then(() => {
          db.collection("posts").doc(postId).update({
            beliked: false,
          });
        });
      this.beLiked = false;
      alert("いいねを消しました。");
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
          this.setUser(user);
        })
        .catch((error) => {
          window.alert(error);
        });
    },
  },
};
</script>

<style scoped>
/* 左から
margin 15%
mainwidth 57.5%
sidemenuwidth 12.5%
=85
margin 15% */

.flex {
  display: flex;
  width: 65%;
  margin: 0 auto;
  padding: 40px 0;
  /* CSSでサイドメニューを固定するための要素 */
  align-items: flex-start;
  color: #4a4141;
}

.like{
  margin: 0 0 0 10px;
}
.dislike {
  color: red;
  margin: 0 0 0 10px;
}
.likecount{
  display: inline;
  margin: 0 10px 0 0 ;
}
.post-container {
  width: 100%;
  height: auto;
  margin: 0 0 0 0;
}
.cafename {
  font-size: 30px;
  font-weight: bold;
  margin: 10px;
}
.post-block {
  width: 100%;
  height: auto;
  margin: 0 auto;
}
hr {
  margin: 15px 0px 20px 0px;
}
.post-info {
  display: flex;
  flex-wrap: wrap;
}
/* イメージ写真とコメントのボックス */
.content-block {
  /* width: 100%;
  height: auto;
  margin: 1% 0;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  border-radius: 3px;
  padding: 10px;
  background-color: white; */
  display: none;
}
/* ユーザのコメント */
.comment-container {
  width: 100%;
  height: auto;
  display: flex;
  flex-wrap: wrap;
}
.user-thumbnail {
  width: 6%;
  height: 6%;
  border-radius: 50%;
  margin:0 0 20px 0;
}
.comment-block {
  padding: 0.5% 2% 2%;
  width: 90%;
  height: auto;
}
#image-container {
  width: 100%;
  height: auto;
  display: flex;
  flex-wrap: wrap;
  margin: 0 0 2% 0;
}
.image-block {
  width: 33%;
  height: 180px;
  }
/* ユーザのコメント */
.image-block img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}
/* メインの写真 */
.image {
  width: 100%;
  height: 400px;
  object-fit: cover;
  border-radius: 3px;
}
.shadow {
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 40px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
}

/* これは各テーブルの間に敷かれている線 */
table tr {
  border-bottom: solid 1px lightgray;
}

table tr:last-child {
  border-bottom: none;
}

table th {
  position: relative;
  text-align: left;
  width: 25%;
  background-color: #4a4141;
  color: white;
  text-align: center;
  padding: 10px 0;
}

table th:after {
  display: block;
  content: "";
  width: 0px;
  height: 0px;
  position: absolute;
  top: calc(50% - 10px);
  right: -10px;
  border-left: 10px solid #4a4141;
  border-top: 10px solid transparent;
  border-bottom: 10px solid transparent;
}

table td {
  text-align: left;
  width: 75%;
  text-align: center;
  background-color: white;
  padding: 10px 0;
}

.resposive-comment-container {
  display: none;
}
.not-resposive-comment-container{
  display: flex;
  flex-wrap: wrap;
}

.map-block {
  width: 100%;
  height: 350px;
  margin-top: 40px;
}

/* サイドメニュー */
.side-menu {
  /* position:fixed; */
  width: 35%;
  display: flex;
  flex-wrap: wrap;
  margin: 0 0 0 5%;
  /* CSSでサイドメニューを固定する */
  position: sticky;
  top: 10px;
}
.side-menu-content {
  margin: 0 0 10px 0;
  
}
.side-menu-title {
  font-size: 22px;
  font-weight: bold;
  margin: 0 0 10px 0;
}
.side-menu-image {
  width: 100%;
  height: 130px;
  object-fit: cover;
}

.side-menu-cafename {
  font-size: 12px;
  font-weight: bold;
}
.side-menu-station {
  font-size: 10px;
  font-weight: bold;
}

@media screen and (max-width: 479px) {
  .post-container {
    width: 100%;
    height: auto;
    padding-top: 0%;
  }
  .cafename {
    font-size: 25px;
    color: black;
    font-weight: bold;
  }

  .image {
    width: 100%;
    height: 300px;
    object-fit: cover;
    border-radius: 0;
  }
  .post-info {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
  .content-block {
    display: none;
  }
  .post-block {
    width: 100%;
    height: auto;
    margin: 0 auto;
    margin-top: 0;
  }
  .post-container {
    margin-bottom: 30px;
  }

  .comment-container,
  .resposive-comment-container,
  #image-container {
    display: block;
    width: 100%;
    height: auto;
    display: flex;
    flex-wrap: wrap;
  }

  .image-block {
    width: 48%;
    height: 180px;
  }

  .user-thumbnail {
    width: 8%;
    height: 8%;
    border-radius: 50%;
  }
  .comment-block {
    padding: 0 2% 2%;
    min-height: 35px;
    width: 88%;

    height: auto;
  }

  table th {
    position: relative;
    text-align: left;
    width: 30%;
    background-color: #4a4141;
    color: white;
    text-align: center;
    padding: 5px 0;
  }

  table th:after {
    display: block;
    content: "";
    width: 0px;
    height: 0px;
    position: absolute;
    top: calc(50% - 10px);
    right: -10px;
    border-left: 10px solid #4a4141;
    border-top: 10px solid transparent;
    border-bottom: 10px solid transparent;
  }

  table td {
    text-align: left;
    width: 70%;
    text-align: center;
    background-color: white;
    padding: 5px 0;
  }
  .map-block {
    width: 100%;
    height: 200px;
    margin: 15px 0px;
  }
  .side-menu {
    display: none;
  }
  .flex {
    width: 100%;
    margin: 0 auto;
    padding: 0 0 30px 0;
  }
  .not-resposive-comment-container{
    display: none;
  }
}
</style>
