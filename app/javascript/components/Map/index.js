import React, {useState, useEffect} from 'react'
import { MapContainer, LayerGroup, LayersControl } from 'react-leaflet'
import html from 'utils/html'
import MapLayer from './map_layer'
import GeoLayer from './geo_layer'
import HexGrid from './hex_grid'
import 'leaflet/dist/leaflet.css';

//const [container, tileLayer] = html.tagify([MapContainer, TileLayer]);

const Map = (props) => {
  console.log('Map', props)
  const mapLayer = (layer, index) => {
    console.log('layer', layer)
    return html.tag(LayersControl.BaseLayer, `layer-${index}`, {
      name: layer.title,
      checked: true // TODO: allow this to be set in DB
    },
      html.tag(MapLayer, `layer-${index}`, layer)
    );
  }

  const viewOptions = {
    center: [2800, 3700],
    //center: [4805, 2100],
    zoom: 2
  }

  const hexes = () => {
    return html.tag(LayersControl.Overlay, `layer-hexes`, {
      name: 'Hexes',
      checked: true // TODO: allow this to be set in DB
    },
      html.tag(HexGrid, 'hex-grid', {...viewOptions, world: props.world})
    );
  }

  const geoLayer = (layer, i) => {
    console.log('Map#geoLayer', layer)
    return html.tag(LayersControl.Overlay, `geo-${i}`, {
      name: layer.name,
      checked: false // TODO: allow this to be set in DB or something
    },
      html.tag(GeoLayer, 'geolayer', layer)
    );
  }

  const geoLayers = () => {
    return props.world.geo_layers.map((layer, i) => {
      return geoLayer(layer, i);
    })
  }

  const layers = () => {
    return html.tag(LayersControl, 'layers', {},
      props.world.map_layers.map((layer, i) => {
        return mapLayer(layer, i);
      }),
      geoLayers(),
      hexes()
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