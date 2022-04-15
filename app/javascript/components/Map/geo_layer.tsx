// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { LayerGroup } from 'react-leaflet'
import GeoLayerCell from './geo_layer_cell'

type GeoLayerProps = {
  name: string;
  cells: []
}

const GeoLayer = (props: GeoLayerProps) => {
  console.log('GeoLayer', props)
  const shapes = () => {
    return props.cells.map((m, i) => {
      console.log('GeoLayer#shapes', m)
      return (<GeoLayerCell key={i} points={m} color="#ff0000"></GeoLayerCell>)
    })
  }

  return (<LayerGroup>{shapes()}</LayerGroup>)
}

export default GeoLayer
