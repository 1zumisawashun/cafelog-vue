<template>
  <div>
    <!-- ここからコンポーネントで使う -->
    <el-input
      type="text"
      v-model="post.cafename"
      placeholder="お店の名前"
      class="form-block"
    />
    <el-input
      type="text"
      v-model="post.station"
      placeholder="最寄駅"
      class="form-block"
    />
    <el-input
      type="text"
      v-model="post.address"
      placeholder="住所"
      class="form-block"
    />
    <el-input
      type="text"
      v-model="post.tel"
      placeholder="電話番号"
      class="form-block"
    />
    <div class="form-block">
      <el-checkbox-button v-model="post.wifi">wi-fiあり</el-checkbox-button>
      <el-checkbox-button v-model="post.date"
        >デートにお勧め</el-checkbox-button
      >
      <el-checkbox-button v-model="post.studying"
        >勉強しやすい</el-checkbox-button
      >
      <el-checkbox-button v-model="post.goodcoffee"
        >こだわりコーヒー</el-checkbox-button
      >
      <el-checkbox-button v-model="post.coffeestand"
        >コーヒースタンド</el-checkbox-button
      >
      <el-checkbox-button v-model="post.stayslone"
        >一人で過ごしやすい</el-checkbox-button
      >
    </div>
    <div class="form-block">
      <star-rating
        v-model="post.rating"
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
      v-model="post.content"
      placeholder="感想"
      class="form-block"
    />
    <el-input
      type="text"
      v-model="post.holiday"
      placeholder="定休日"
      class="form-block"
    />
    <div class="form-block">
      <el-checkbox-button v-model="post.open">開店</el-checkbox-button>
      <el-checkbox-button v-model="post.close">閉店</el-checkbox-button>
    </div>
    <el-input
      type="text"
      v-model.number="post.lat"
      placeholder="緯度"
      class="form-block"
    />
    <!-- v-model.numberにすることで数値でデータが登録される -->
    <el-input
      type="text"
      v-model.number="post.lng"
      placeholder="経度"
      class="form-block"
    />
    <div id="image-container">
      <div v-if="!post.image">
        <input type="file" @change="onFileChange" class="form-block" />
      </div>
      <div v-else>
        <div class="form-block">
          <img :src="post.image" class="postedImage" />
          <el-button @click="removeImage">Remove</el-button>
        </div>
      </div>
    </div>
    <div class="form-block">
      <el-button @click="$emit('update', post)">UPDATE</el-button>
    </div>
    <!-- ここまでコンポーネントで切り離す -->
  </div>
</template>

<script>
import StarRating from "vue-star-rating";
//import { db } from "@/firebase";
export default {
  data() {
    return {
      newfile: [],
      image: ""
    };
  },
  props: ["post"],
  components: {
    StarRating
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  mounted() {
    console.log(this.post);
    console.log(this.post.image);
  },
  methods: {
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
      console.log(vm.image)
      reader.onload = function(event) {
        vm.post.image = event.target.result;
        //vm.imageだとエラーになる。ここでかなり詰まったので注意。
        console.log(event.target.result)
        //これもthis.imageだよ！
        console.log(vm.image)
        alert("写真を読み込んでいるよ")
      };
      reader.readAsDataURL(file);
      this.post.file = file
      //fileの要素をpostの中に入れて一気にemitするため→二個以上の要素をemitで出せるか検証中
      console.log(this.post);
      
    },
    removeImage: function() {
      //this.image = ""; updateができない
      this.post.image = "";
      alert("写真を消すよ")
    },
    setRating: function(rating) {
      this.rating = rating;
      console.log(this.rating);
    },
  }
};
</script>

<style scoped>
.postedImage {
  width: 150px;
  height: auto;
}
.form-block {
  margin: 3px;
}
</style>


