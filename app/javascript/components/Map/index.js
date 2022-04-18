import * as React from 'react'
import * as Leaflet from 'react-leaflet'
import { MapContainer, LayerGroup, LayersControl, useMapEvents, ScaleControl } from 'react-leaflet'
import { MapSelectionContext } from './map_context'
import html from 'utils/html'
import MapLayer from './map_layer'
import GeoLayer from './geo_layer'
import HexGrid from './hex_grid'
import SideBar from './side_bar'
import 'leaflet/dist/leaflet.css'
import './map.css'
import GeoLayerGrid from './geo_layer_grid'
import { zoom } from 'leaflet/src/control/Control.Zoom'

// const [container, tileLayer] = html.tagify([MapContainer, TileLayer]);

const Map = (props) => {
  console.log('Map', props)
  console.log('mapCenter', localStorage.getItem('mapCenterX'), localStorage.getItem('mapCenterY'))
  const [selectedObject, setSelectedObject] = React.useState(null);
  const [mapMode, setMapMode] = React.useState('continents');

  const selectedObjectContext = () => {
    return {
      selectedObject: selectedObject,
      setSelectedObject: setSelectedObject
    }
  }

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
    center: [
      localStorage.getItem('mapCenterY') ?? 2800,
      localStorage.getItem('mapCenterX') ?? 3700
    ],
    // center: [4805, 2100],
    zoom: localStorage.getItem('mapZoom') ?? 2
  }

  const hexes = () => {
    return <LayersControl.Overlay
      name='Hexes'
      checked={true}>
        <HexGrid {...viewOptions} world={props.world} setSelectedObject={setSelectedObject}></HexGrid>
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
    return (
      <div className="leaflet-control-container">
        <div className="leaflet-bottom leaflet-left">
          <div className="leaflet-bar leaflet-control panel">
            {['continents', 'subcontinents', 'regions', 'areas', 'provinces', 'hexes'].map((layer) => {
              return (
                <a
                  className={mapMode === layer ? 'current' : ''}
                  onClick={() => setMapMode(layer)}>
                  {mapMode === layer ? '*' : '' } {layer}
                </a>
              );
            })}
          </div>
        </div>

      </div>

    )
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

  const geoLayerGrid = () => {
    return html.tag(GeoLayerGrid, 'grid', { mapMode: mapMode, world: props.world });
  }

  const layers = () => {
    return html.tag(LayersControl, 'layers', {},
      props.world.map_layers.map((layer, i) => {
        return mapLayer(layer, i)
      }),
      // geoLayers(),
      geoLayerGrid(),
      // hexes(),
      html.tag(Control, 'control', {position: 'bottomleft'}, 'test')
      // html.tag(ScaleControl, 'scale', {position: 'bottomright'})
    )
  }

  // yo
  const mapContainer = () => {
    console.log('mapContainer', L.CRS.Simple.scale(1))
    return html.tag(MapContainer, 'test', {
      className: 'map-container',
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
    return <SideBar
      class="map-sidebar"
      setSelectedObject={setSelectedObject}
      selectedObject={selectedObject}
    ></SideBar>
  }

  return (
    <MapSelectionContext.Provider value={selectedObjectContext()}>
      <div class="map-component">
        {mapContainer()}
        {sideBar()}
      </div>
    </MapSelectionContext.Provider>
  )
}

export default Map
