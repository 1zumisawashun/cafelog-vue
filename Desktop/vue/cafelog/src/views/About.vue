<template>
  <div class="app">
    <div id="map">
      <GmapMap :center="center" :zoom="zoom" ref="map" style="width: 100%; height: 500px;">
        <GmapMarker
          v-for="(m, id) in marker_items"
          :position="m.position"
          :title="m.title"
          :clickable="true"
          :draggable="false"
          :key="id"
        ></GmapMarker>
      </GmapMap>
      <p>
        <button @click="getInfo">地図情報の取得</button>
      </p>
      <p v-for="(info, id) in infos" :key="id">{{ info }}</p>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      center: { lat: 35.71, lng: 139.72 },
      zoom: 14,
      marker_items: [
        { position: { lat: 35.71, lng: 139.72 }, title: "marker_1" },
        { position: { lat: 35.72, lng: 139.73 }, title: "marker_2" },
        { position: { lat: 35.7, lng: 139.71 }, title: "marker_3" },
        { position: { lat: 35.71, lng: 139.7 }, title: "marker_4" }
      ],
      infos: []
    };
  },
  methods: {
    getInfo() {
      let mapBounds = this.$refs.map.$mapObject.getBounds();
      this.infos.push(`[bounds-lat:] ${mapBounds.la.j} ～ ${mapBounds.la.l}`);
      this.infos.push(`[bounds-lng:] ${mapBounds.ea.j} ～ ${mapBounds.ea.l}`);
      let center = this.$refs.map.$mapObject.getCenter();
      this.infos.push(`[center] lat: ${center.lat()} lng: ${center.lng()}`);
    }
  }
};
</script>
