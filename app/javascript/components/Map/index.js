import React from 'react'
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet'
import html from 'utils/html'

//const [container, tileLayer] = html.tagify([MapContainer, TileLayer]);

const Map = (props) => {
  console.log('html', html)
  return html.tag(MapContainer, 'test', {
    key: 'test',
    center: [51.505, -0.09],
    zoom: 13,
    scrollWheelZoom: false
  }, [
    React.createElement(TileLayer, {
      key: 'test',
      attribution: 'test',
      url:"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    })
  ]);
}

export default Map;