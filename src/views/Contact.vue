<template>
  <div class="contact-container">
    <div class="first-contact-block">
      <div class="logo-block">
        <img src="@/assets/logo.jpg" class="contact-logo" />
      </div>
      <div class="contact-title">
        好きなカフェを見つける
      </div>
      <!-- <VueSlickCarousel v-bind="setting" class="slick-carousel-container">
        <div class="test"><img src="@/assets/test15.jpg" class="img" /></div>
        <div class="test">test2</div>
      </VueSlickCarousel> -->
      <div class="contact-text">
        テレワーク、勉強、デート、一人でゆっくり過ごしたい、コーヒーの好み、
        など目的によって適しているカフェは異なります。
        カフェログでは一人一人が目的に応じたお店を見つけることが
        できるようなカフェ情報をお届けします。
      </div>
    </div>
    <div class="second-contact-block">
      <div class="contact-title">カフェログでは仲間を募集しています。</div>
      <div class="contact-text">
        カフェ好きな仲間を募集しています。
        様々なカフェを投稿しカフェログの拡大のお手伝いをお願いします。
      </div>
    </div>
    <div class="third-contact-block">
      <div class="contact-title">応募は以下から</div>
      <div class="contact-text">
        cafelog@gmail.com
      </div>
    </div>
  </div>
</template>

<script>
// import VueSlickCarousel from "vue-slick-carousel";
// import "vue-slick-carousel/dist/vue-slick-carousel.css";
// // optional style for arrows & dots
// import "vue-slick-carousel/dist/vue-slick-carousel-theme.css";
export default {
  data() {
    return {
      posts: [],
      setting: {
        dots: true,
        slidesToShow: 1,
        infinite: true,
        autoplay: true,
        autoplayTimeout: 2000,
        arrows: false
      }
    };
  }
  // components: {
  //   VueSlickCarousel
  // }
};
</script>

<style>
.slick-carousel-container {
  width: 100%;
  height: 100px;
}
.test {
  width: auto;
  height: 200px;
}
.img {
  width: 100%;
  height: auto;
  object-fit: cover;
}
.contact-container {
  width: 100%;
  margin: 0 auto;
}
.logo-block {
  width: 150px;
  margin: 0 auto;
}
.contact-logo {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  margin: 0 auto;
}

.contact-title {
  font-size: 50px;
  font-weight: bold;
  text-align: center;
}
.contact-text {
  margin: 0 50px;
  font-size: 30px;
  font-weight: bold;
  text-align: center;
}

.first-contact-block {
  width: 90%;
  height: auto;
  background-color: whitesmoke;
  padding: 5%;
}
.second-contact-block {
  width: 90%;
  height: auto;
  background-color: white;
  padding: 5%;
}
.third-contact-block {
  width: 90%;
  height: auto;
  background-color: lightgray;
  padding: 5%;
}
</style>
