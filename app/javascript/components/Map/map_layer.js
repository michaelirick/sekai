import {ImageOverlay} from 'react-leaflet'
import html from 'utils/html'
import api from 'utils/api'
import {useState, useEffect} from 'react'

const MapLayer = (props) => {
  console.log('MapLayer', props)
  return html.tag(ImageOverlay, 'overlay', {
    bounds: new L.LatLngBounds([-90, -180], [90, 180]),
    url: props.url
  });
}

export default MapLayer;