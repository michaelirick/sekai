// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { ImageOverlay } from 'react-leaflet'

type MapLayerProps = {
  url: string;
}

const MapLayer = (props: MapLayerProps) => {
  // console.log('MapLayer', props)
  return <ImageOverlay bounds={[[0, 0], [4096, 8192]]} url={props.url}></ImageOverlay>
}

export default MapLayer
