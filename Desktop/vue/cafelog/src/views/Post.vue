<template>
  <!-- eslint-disable  -->
  <div class="post-container">
    <div class="post-block">
      <div v-for="(post, index) in post" :key="index">
        <span class="cafename">{{ post.cafename }}</span>
        <div class="post-info">
          <img :src="post.image" class="image shadow" />
          <div class="content-block">
            投稿者のコメント
            <p>{{ post.content }}</p>
          </div>
        </div>
        <div class="beLiked">
          <el-button v-if="beLiked" @click="unlikes()" type="danger" class="shadow">いいね</el-button>
          <el-button v-else @click="likes()" class="shadow">いいね</el-button>
          {{likeCount}}
          <el-button class="open shadow" v-show="post.open">開店</el-button>
          <el-button class="close shadow" v-show="post.close" type="danger">閉店</el-button>
        </div>

        <hr />
        <p>コメント一覧</p>
        <div v-for="(comment, index) in comments" :key="index">
          <div class="comment-container">
            <img :src="comment.thumbnail" alt class="user-thumbnail" />
            <div class="comment-block">
              <div class="user-name">{{ comment.username }}</div>
              <div class="comment-content">{{ comment.comment }}</div>
            </div>
          </div>
        </div>
        <el-button type="primary" class="shadow" @click="openCommentModal">コメントする</el-button>
        <el-dialog cafename :visible.sync="CommentDialogVisible" width="70%">
          <div>コメントを記入してください。</div>
          <el-input type="text" v-model="comment" />
          <el-button @click="addComment(post.id)">コメントする</el-button>
        </el-dialog>

        <hr />

        <p>写真一覧</p>
        <div id="image-container">
          <div v-for="(image, index) in images" :key="index" class="image-block">
            <img :src="image.image" class="picture" alt />
          </div>
        </div>
        <el-button type="primary" class="shadow" @click="openImageModal">写真を投稿する</el-button>

        <el-dialog cafename :visible.sync="ImageDialogVisible" width="70%">
          <p>写真を投稿してください。</p>
          <div class="image-container">
            <div v-if="!image">
              <input type="file" @change="onFileChange" class="file-container" />
            </div>
            <div v-else>
              <img :src="image" class="image" />
              <el-button @click="removeImage">Remove</el-button>
              <el-button @click="addImage()">post</el-button>
            </div>
          </div>
        </el-dialog>

        <hr />
        <table>
          <tr>
            <th>最寄駅</th>
            <td>{{ post.station }}</td>
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
          <tr>
            <th>wi-fiの有無</th>
            <td v-show="post.wifiless">無し</td>
            <td v-show="post.wifi">有り</td>
          </tr>
        </table>

        <div>
          <GmapMap
            :center="{lat:10, lng:10}"
            :zoom="7"
            map-type-id="terrain"
            class="shadow"
            style="width: 100%; height: 300px; margin-top:25px;"
          >
            <GmapMarker :key="index" :clickable="true" :draggable="true" />
            <!-- 
              :position="m.position"v-for="(m, index) in markers"
            @click="center=m.position"-->
          </GmapMap>
        </div>
        <!--eslint-disable-->
        <div class="chat-maker">
          <el-button
            @click="makeChannels(post.cafename, post.user.id, post.image)"
            v-show="eraseChat"
          >chat-maker</el-button>
        </div>
      </div>
      <div style="margin-top:25px;">
        <router-link to="/posts">戻る</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import { db, firebase } from "@/firebase";
export default {
  data() {
    return {
      post: [],
      CommentDialogVisible: false,
      ImageDialogVisible: false,
      updateContent: "",
      eraseElement: false,
      eraseChat: true,
      comments: [],
      comment: "",
      images: [],
      image: "", //event.target.result→すごく長い文字列が格納されている
      file: "", //写真の情報が格納されている
      url: null, //storageの情報が格納されている
      beLiked: false,
      likeCount: 0
    };
  },
  computed: {
    userId() {
      return this.$store.state.user.uid;
    },
    user() {
      return this.$store.state.user;
    }
  },
  mounted() {
    //いいねを付ける、取り外しをする
    console.log(this.beLiked);
    console.log(this.post);

    const postId = this.$route.params.id;
    const userid = this.userId; //よくわからないがuseridを再度定義しないとエラーになる為記載
    db.collection("posts")
      .doc(postId)
      .collection("likes")
      .where("username", "==", userid)
      .get()
      .then(doc => {
        if (doc.docs.length === 1) {
          this.beLiked = true;
          console.log(this.beLiked);
        } else {
          this.beLiked = false;
          console.log(this.beLiked);
        }
      });
    //いいねをカウントする
    const likeRef = db
      .collection("posts")
      .doc(postId)
      .collection("likes");
    likeRef.onSnapshot(snap => {
      this.likeCount = snap.size;
    });

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
          console.log(this.eraseElement);
        }
      });

    db.collection("posts")
      .doc(postsId)
      .collection("comments")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.comments.push({ id: doc.id, ...doc.data() });
          console.log(doc.data().id);
        });
      });
    db.collection("posts")
      .doc(postsId)
      .collection("images")
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          this.images.push({ id: doc.id, ...doc.data() });
          console.log(doc.data().id);
        });
      });
  },
  methods: {
    openCommentModal() {
      this.CommentDialogVisible = true;
    },
    openImageModal() {
      this.ImageDialogVisible = true;
    },
    update(id) {
      db.collection("posts")
        .doc(id)
        .update({ content: this.updateContent })
        .then(() => {
          alert("メッセージの更新に成功しました");
        });
    },
    makeChannels(cafename, postedUserId, image) {
      console.log("makeChannels");
      db.collection("channels").add({
        name: cafename,
        postedUser: postedUserId,
        currentUser: this.userId,
        createdAt: new Date().getTime(),
        thumbnail: image
      });
      window.alert("chat-maker");
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
        });
      alert("コメントの追加をしました");
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
          storageRef.getDownloadURL().then(url => {
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
                  thumbnail: this.user.photoURL
                }
              });
          });
          console.log(this.url);
          window.alert("firestoreに格納しました");
        });
        this.image = null;
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
          username: this.userId,
          cafename: this.post[0].cafename,
          station: this.post[0].station,
          image: this.post[0].image,
          id: this.post[0].id,
          thumbnail: this.user.photoURL
        });
      this.beLiked = true;
      alert("いいねしました。");
      db.collection("users").where;
    },
    unlikes() {
      const postId = this.$route.params.id;
      db.collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(this.userId)
        .delete();
      this.beLiked = false;
      alert("いいねを消しました。");
    }
  }
};
</script>

<style scoped>
.post-container {
  width: 100%;
  height: auto;
}
.cafename {
  font-size: 30px;
  font-weight: bold;
}

.post-block {
  width: 70%;
  height: auto;
  margin: 0 auto;
  padding-top: 50px;
}
.post-info {
  display: flex;
  margin-bottom: 25px;
}
/* イメージ写真とコメントのボックス */
.content-block {
  width: 65%;
  height: auto;
  margin: 0 0 0 3%;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
  border-radius: 10px;
  padding: 10px;
  background-color: white;
}
/* ユーザのコメント */
.comment-container,
#image-container {
  width: 100%;
  height: auto;
  display: flex;
  flex-wrap: wrap;
}

.image-block {
  width: 25%;
  height: 180px;
}
.user-thumbnail {
  width: 5%;
  height: 5%;
  border-radius: 50%;
}
.comment-block {
  padding: 1%;
  width: 93%;
  height: auto;
}
/* ユーザのコメント */
.image-block img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}

.image {
  width: 40%;
  height: 270px;
  object-fit: cover;
  border-radius: 10px;
}

.shadow {
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
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
  width: 30%;
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
  width: 70%;
  text-align: center;
  background-color: white;
  padding: 10px 0;
}

@media screen and (max-width: 479px) {
  .image {
    width: 100%;
    height: auto;
  }
  .post-info {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
  .content-block {
    width: 100%;
    margin: 0;
  }
  .post-block {
    width: 90%;
    height: auto;
    margin: 0 auto;
    margin-top: 50px;
  }
}
</style>
