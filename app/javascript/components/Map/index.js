import React from 'react'
import { MapContainer, TileLayer, Marker, Popup, ImageOverlay, LayerGroup, ZoomControl } from 'react-leaflet'
import html from 'utils/html'
import MapLayer from './map_layer'
import 'leaflet/dist/leaflet.css';

//const [container, tileLayer] = html.tagify([MapContainer, TileLayer]);

const Map = (props) => {
  console.log('Map', props)
  const mapLayer = (layer, index) => {
    return html.tag(MapLayer, `layer-${index}`, layer);
  }

  const layers = () => {
    return html.tag(LayerGroup, 'layers', {},
      props.world.map_layers.map((layer, i) => {
        return mapLayer(layer, i);
      })
    );
  }

  return html.tag(MapContainer, 'test', {
    key: 'test',
    center: [51.505, -0.09],
    zoom: 9,
    scrollWheelZoom: false,
    style: {
      height: '600px',
      maxHeight: '600px',
      maxWidth: '800px'
    },
    crs: L.CRS.EPSG4326
  }, [
    layers(),
    // html.tag(ZoomControl, 'zoom')
    //html.tag(ImageOverlay, 'layer')
    // React.createElement(TileLayer, {
    //   key: 'test',
    //   attribution: 'test',
    //   url:"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    // })
  ]);
}

export default Map;