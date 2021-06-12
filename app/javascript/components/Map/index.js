import React, {useState, useEffect} from 'react'
import { MapContainer, LayerGroup } from 'react-leaflet'
import html from 'utils/html'
import MapLayer from './map_layer'
import HexGrid from './hex_grid'
import 'leaflet/dist/leaflet.css';

//const [container, tileLayer] = html.tagify([MapContainer, TileLayer]);

const Map = (props) => {
  console.log('Map', props)
  const mapLayer = (layer, index) => {
    return html.tag(MapLayer, `layer-${index}`, layer);
  }

  const viewOptions = {
    center: [2800, 3700],
    zoom: 2
  }

  const layers = () => {
    return html.tag(LayerGroup, 'layers', {},
      props.world.map_layers.map((layer, i) => {
        return mapLayer(layer, i);
      }),
      html.tag(HexGrid, 'hex-grid', {...viewOptions, world: props.world})
    );
  }

  return html.tag(MapContainer, 'test', {
    key: 'test',
    ...viewOptions,
    minZoom: -10,
    // scrollWheelZoom: false,
    style: {
      height: '600px',
      maxHeight: '600px',
      maxWidth: '800px'
    },
    crs: L.CRS.Simple
  }, [
    layers(),
  ]);
}

export default Map;