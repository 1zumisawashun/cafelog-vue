<template>
  <!-- ページ数が1より大きい、2ページ以上の時のみページネーションを表示 -->
  <!-- 戻るボタンなので１個づつ戻る操作が必要になる -->
  <div v-if="length > 1" class="list-item list-item-nav">
    <el-button
      class="btn btn-prev"
      size="small"
      @click="$router.push(`?${query}=${now - 1 || 1}`)"
    >
      <!-- 例：「?number=3」がクエリに入ってリンクが飛ぶ -->
      戻る
    </el-button>
    <ul class="list">
      <!-- 1ページ目はどんな時でも固定表示のためif不要 -->
      <!-- クラスバインディング、{ class名: 式 }でtrueの時にクラスがつく -->
      <li
        :class="{ now: now === 1 }"
        class="item item-link"
        @click="$router.push(`?${query}=1`)"
      >
        <!-- // 1ページを押すとurlが~/1になる -->
        <span class="text">
          1
        </span>
      </li>
      <!-- 🌟ここから分岐、最大ページ数が2より大きい3〜 -->
      <template v-if="length > 2">
        <!-- 🍀3以上5以下(=最大ページ数3,4,5の時)
            5ページまでの場合は、最大ページ数に応じて該当ページ数を表示 -->
        <template v-if="length <= 5">
          <li
            :class="{ now: now === 2 }"
            class="item item-link"
            @click="$router.push(`?${query}=2`)"
          >
            <span class="text">
              2
            </span>
          </li>
          <!-- 💭最大ページ数が3, 4, 5かつ3より大きい4, 5の時 -->
          <template v-if="length > 3">
            <li
              :class="{ now: now === 3 }"
              class="item item-link"
              @click="$router.push(`?${query}=3`)"
            >
              <span class="text">
                3
              </span>
            </li>
            <!-- 🍰最大ページ数が3, 4, 5かつ3より大きい4, 5かつ4より大きい5の時 -->
            <template v-if="length > 4">
              <li
                :class="{ now: now === 4 }"
                class="item item-link"
                @click="$router.push(`?${query}=4`)"
              >
                <span class="text">
                  4
                </span>
              </li>
            </template>
          </template>
        </template>
        <!-- 🍀でなければ(=最大ページが5より大きい6〜) -->
        <template v-else>
          <!-- 🐥最大ページ6〜かつ現在いるページが4より少ない(=1, 2, 3の時) -->
          <template v-if="now < 4">
            <li
              :class="{ now: now === 2 }"
              class="item item-link"
              @click="$router.push(`?${query}=2`)"
            >
              <span class="text">
                2
              </span>
            </li>
            <li
              :class="{ now: now === 3 }"
              class="item item-link"
              @click="$router.push(`?${query}=3`)"
            >
              <span class="text">
                3
              </span>
            </li>
            <!-- 🍭現在いるページが4より少ないかつ、3ページ目にいる時 -->
            <li
              v-if="now === 3"
              class="item item-link"
              @click="$router.push(`?${query}=4`)"
            >
              <span class="text">
                4
              </span>
            </li>
            <li class="item item-dots">
              <!-- このドットは「・・・」の要素になる -->
              <div class="dot" />
              <div class="dot" />
              <div class="dot" />
            </li>
          </template>
          <!-- 🐥最大ページ6〜かつ現在いるページが1, 2, 3でなく4で〜
          現在いるページに2を出しても最大ページ数と同じか少なければ
          (4ページ目にいるなら4 +
          2、最大ページ7の方が大きいためfalse) (6ページ目にいるなら6 +
          2、最大ページ7より大きいためtrue) -->
          <template v-else-if="length <= now + 2">
            <li class="item item-dots">
              <div class="dot" />
              <div class="dot" />
              <div class="dot" />
            </li>
            <!-- 🌷最大ページ数から2を引いた数字が現在いるページだったら
            最大ページ数から3を引いたページ数を表示させる
            (5ページ目にいるなら7-2 =5でtrue、7-3
            =4が表示される) -->
            <li
              v-if="now === length - 2"
              class="item item-link"
              @click="$router.push(`?${query}=${length - 3}`)"
            >
              <span class="text">
                {{ length - 3 }}
              </span>
            </li>
            <li
              :class="{ now: now === length - 2 }"
              class="item item-link"
              @click="$router.push(`?${query}=${length - 2}`)"
            >
              <span class="text">
                {{ length - 2 }}
              </span>
            </li>
            <li
              :class="{ now: now === length - 1 }"
              class="item item-link"
              @click="$router.push(`?${query}=${length - 1}`)"
            >
              <span class="text">
                {{ length - 1 }}
              </span>
            </li>
          </template>
          <!-- 🐥最大ページ6〜かつ、今までのパターンに該当しない
          (上の🐥のfalse、現在4ページの場合) -->
          <template v-else>
            <li class="item item-dots">
              <div class="dot" />
              <div class="dot" />
              <div class="dot" />
            </li>
            <li
              class="item item-link"
              @click="$router.push(`?${query}=${now - 1}`)"
            >
              <span class="text">
                {{ now - 1 }}
              </span>
            </li>
            <li class="item item-link now">
              <span class="text">
                {{ now }}
              </span>
            </li>
            <li
              class="item item-link"
              @click="$router.push(`?${query}=${now + 1}`)"
            >
              <span class="text">
                {{ now + 1 }}
              </span>
            </li>
            <li class="item item-dots">
              <div class="dot" />
              <div class="dot" />
              <div class="dot" />
            </li>
          </template>
        </template>
      </template>
      <li
        :class="{ now: now === length }"
        class="item item-link"
        @click="$router.push(`?${query}=${length}`)"
      >
        <span class="text">
          {{ length }}
        </span>
      </li>
    </ul>
    <el-button
      class="btn btn-next"
      size="small"
      @click="$router.push(`?${query}=${now + 1 <= length ? now + 1 : length}`)"
    >
      進む
    </el-button>
  </div>
</template>

<script>
export default {
  props: {
    query: {
      type: String,
      required: true
    },
    length: {
      type: Number,
      required: true
    },
    now: {
      type: Number,
      required: true
    }
  }
};
</script>

<style>
/* scopedをつけると要素が効かなくなる */
ul {
  list-style: none;
}
.list-item {
  justify-content: center;
  height: 50px;
  margin: 0 auto;
  display: flex;
}
.list {
  height: 50px;
  display: flex;
}
.item-link {
  width: 50px;
  height: 30px;
}
.item-dots {
  display: flex;
  width: 30px;
  justify-content: center;
}
.dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background-color: black;
}
.item {
  text-align: center;
  margin: 10px 0 0 0;
}
</style>
