// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { ImageOverlay } from 'react-leaflet'
import { useContext } from 'react'
import { MapSelectionContext } from './map_context'

type MapLayerProps = {
  url: string;
}

const MapLayer = (props: MapLayerProps) => {
  const mapSelection = useContext(MapSelectionContext)

  // console.log('MapLayer', props)
  return <ImageOverlay bounds={[[0, 0], [mapSelection.world.resolution_y, mapSelection.world.resolution_x]]} url={props.url}></ImageOverlay>
}

export default MapLayer
