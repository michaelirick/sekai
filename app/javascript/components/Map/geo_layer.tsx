// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { LayerGroup } from 'react-leaflet'
import GeoLayerCell from './geo_layer_cell'

type GeoLayerProps = {
  geometry?: string
}

const GeoLayer = (props: GeoLayerProps) => {
  console.log('GeoLayer', props)
  const shapes = () => {
    return <GeoLayerCell geometry={props.geometry} color="#ff0000"></GeoLayerCell>
    // return props.points.map((m, i) => {
    //   console.log('GeoLayer#shapes', m)
    //   return (<GeoLayerCell key={i} points={m} color="#ff0000"></GeoLayerCell>)
    // })
  }

  return (<LayerGroup>{shapes()}</LayerGroup>)
}

export default GeoLayer
