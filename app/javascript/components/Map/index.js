import * as React from 'react'
import * as Leaflet from 'react-leaflet'
import { MapContainer, LayerGroup, LayersControl } from 'react-leaflet'
import html from 'utils/html'
import MapLayer from './map_layer'
import GeoLayer from './geo_layer'
import HexGrid from './hex_grid'
import SideBar from './side_bar'
import 'leaflet/dist/leaflet.css'

// const [container, tileLayer] = html.tagify([MapContainer, TileLayer]);

const Map = (props) => {
  console.log('Map', props)
  const mapLayer = (layer, index) => {
    console.log('layer', layer)
    return <LayersControl.BaseLayer
      key={`layer-${index}`}
      name={layer.title}
      checked={true}
    >
      <MapLayer key={`layer-${index}`} {...layer}></MapLayer>
    </LayersControl.BaseLayer>
  }

  const viewOptions = {
    center: [2800, 3700],
    // center: [4805, 2100],
    zoom: 2
  }

  const hexes = () => {
    return <LayersControl.Overlay
      name='Hexes'
      checked={true}>
        <HexGrid {...viewOptions} world={props.world}></HexGrid>
      </LayersControl.Overlay>
  }

  const geoLayer = (name, cells, i) => {
    console.log('Map#geoLayer', name, cells)
    return <LayersControl.Overlay name={name} checked={false} key={i}>
      <GeoLayer name={name} cells={cells}></GeoLayer>
    </LayersControl.Overlay>
  }

  const geoLayers = () => {
    // return null;
    return Object.entries(props.world.geo_layers).map(([name, cells], i) => {
      return geoLayer(name, cells, i)
    })
  }

  const Control = (props) => {
    return <div></div>
    // <div class="leaflet-control-zoom leaflet-bar leaflet-control">
    // <a class="leaflet-control-zoom-in" href="#" title="Zoom in" role="button" aria-label="Zoom in">
    // +
    // </a>
    // <a class="leaflet-control-zoom-out" href="#" title="Zoom out" role="button" aria-label="Zoom out">
    // −
    // </a>
    // </div>
    // return html.div('control', { className: 'leaflet-control leaflet-bar' }, 'test')
  }

  const layers = () => {
    return html.tag(LayersControl, 'layers', {},
      props.world.map_layers.map((layer, i) => {
        return mapLayer(layer, i)
      }),
      geoLayers(),
      hexes()
      // html.tag(Control, 'control', {position: 'bottomleft'}, 'test')
    )
  }

  // yo
  const mapContainer = () => {
    console.log('mapContainer')
    return html.tag(MapContainer, 'test', {
      key: 'test',
      ...viewOptions,
      minZoom: -10,
      // scrollWheelZoom: false,
      style: {
        height: '600px',
        maxHeight: '600px',
        maxWidth: '800px'
        // float: 'left'
      },
      crs: L.CRS.Simple
    }, [
      layers()//,
      // html.tag(Control, 'control', { position: 'bottomleft' }, 'test')
    ])
  }

  const sideBar = () => {
    return <SideBar></SideBar>
  }

  return <div>
    {mapContainer()}
    {sideBar()}
  </div>
}

export default Map
