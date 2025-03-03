// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { LayerGroup } from 'react-leaflet'
import GeoLayerCell, {GeoLayerCellProps} from './geo_layer_cell'

type GeoLayerProps = {
  name: string;
  cells: GeoLayerCellProps[]
}

const GeoLayer = (props: GeoLayerProps) => {
  // console.log('GeoLayer', props)
  const shapes = () => {
    return props.cells.map((m, i) => {
      // console.log('GeoLayer#shapes', m)
      return (<GeoLayerCell layer={props.name} id={m.id} name={m.name} key={i} points={m.points} color="#ff0000"/>)
    })
  }

  return (<LayerGroup>{shapes()}</LayerGroup>)
}

export default GeoLayer
