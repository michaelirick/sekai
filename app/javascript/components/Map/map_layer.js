import {ImageOverlay} from 'react-leaflet'
import html from 'utils/html'
import api from 'utils/api'
import {useState, useEffect} from 'react'

const MapLayer = (props) => {
  console.log('MapLayer', props)
  return html.tag(ImageOverlay, 'overlay', {
    bounds: [[0, 0], [4096, 8192]],//new L.LatLngBounds(), // TODO: pass from props?
    url: props.url
  });
}

export default MapLayer;