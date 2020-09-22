import firebase from "firebase";
import "firebase/auth";
import "firebase/firestore";

if (!firebase.apps.length) {
  const config = {
    apiKey: "AIzaSyBtWqRoKlSft9Gj9qZhIIC_nYmNrx6E3wg",
    authDomain: "vuestagram-20f8d.firebaseapp.com",
    databaseURL: "https://vuestagram-20f8d.firebaseio.com",
    projectId: "vuestagram-20f8d",
    storageBucket: "vuestagram-20f8d.appspot.com",
    messagingSenderId: "1041755303397",
    // eslint-disable-next-line
    appId: "1:1041755303397:web:d17c2a36f65cde77e7530c",
  };
  firebase.initializeApp(config);
}

const db = firebase.firestore();
export { firebase, db };

// xporet const add = collection().doc
// のようにデータをあらかじめ決めることで省略で書くことができる
