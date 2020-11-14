<template>
  <div></div>
</template>

<script>
import { db } from "@/firebase";
export default {
  mounted() {
    db.collection("posts").onSnapshot(snapshot => {
      snapshot.docChanges().forEach(change => {
        /*eslint-disable*/
        //docChanges()を使用するとtypeが分かる
        const doc = change.doc;
        if (change.type === "modified") {
          console.log("modifiedされました");
          this.post[0] = { id: doc.id, ...doc.data() };
          console.log(this.post);
        } else if (
          change.type === "added" &&
          change.doc.id === this.$route.params.id
        ) {
          this.post.push({ id: doc.id, ...doc.data() });
          if (this.user.uid === change.doc.data().user.id) {
            //もしcurrentUserとpostedUserが同じだったら、下の要素が発動
            this.eraseElement = true;
            //編集ボタンが出現する
            this.eraseChat = false;
            //chat-makerが消える
            console.log(this.eraseElement);
          }
        }
      });
    });
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
            this.messages.push({ id: doc.id, ...doc.data() });
          } else if (change.type === "removed") {
            const num = this.messages.length - 1;
            const element = this.messages;
            for (let i = 0; i <= num; i++) {
              if (doc.id === element[i].id) {
                this.messages.splice(i, 1);
              }
            }
          }
        });
      });
    db.collectionGroup("likes")
      //collectionGroupではwhereを使用することはできないため全部のユーザデータを取得
      .onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
          const doc = change.doc;
          if (change.type === "added") {
          if (doc.data().currentUser === this.user.uid) {
            this.likesFiltered.push({
              //この中にログインしているユーザがいいね押しているカフェが入っている。
              id: doc.id,
              ...doc.data()
            });
            console.log(this.likesFiltered);
            //もしログインしているユーザがいいねしたカフェの店名とカードのカフェの名前が同じだったら色を変える。
            for (var i in this.likesFiltered) {
              console.log(i);
              //上記のfor文の使い方だと数字が入るようになる。条件式に注目する。
              if (this.likesFiltered[i].cafename == this.post.cafename) {
                this.daisuki = true;
                console.log("実行できています");
              }
            }}
          }
          //else if (change.type === "removed") {
          //for in分で
          //const num = this.likesFiltered.length - 1;
          //const element = this.likesFiltered;
          //for (let i = 0; i <= num; i++) {
          //if (doc.id === element[i].id) {
          //this.likesFiltered.splice(i, 1);
          //}
          //}
          // }
        });
      })
      .then(querySnapshot => {
        querySnapshot.forEach(doc => {
          //これがwhereの代わりになっている。ログインしているユーザがいいねしたデータのみ取得
          if (doc.data().currentUser === this.user.uid) {
            this.likesFiltered.push({
              //この中にログインしているユーザがいいね押しているカフェが入っている。
              id: doc.id,
              ...doc.data()
            });
            //もしログインしているユーザがいいねしたカフェの店名とカードのカフェの名前が同じだったら色を変える。
            for (var i in this.likesFiltered) {
              console.log(i);
              //上記のfor文の使い方だと数字が入るようになる。条件式に注目する。
              if (this.likesFiltered[i].cafename == this.post.cafename) {
                this.daisuki = true;
                console.log("実行できています");
              }
            }
          }
        });
      });
  }
};
</script>

<style></style>
