// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { GeoJSON, Popup, Tooltip } from 'react-leaflet'
import { MapSelectionContext } from './map_context'

import './geo_layer_cell.css'

export type GeoLayerCellProps = {
  id: number;
  name: string;
  pathOptions?: unknown;
  points: [];
  color?: string;
  layer: string;
}

type TooltipProps = {
  name: string;
  layer: string;
}

const GeoLayerLabel = ({ name, layer }: TooltipProps) => {
  return (
    <Tooltip
      direction='center'
      className={`geo-layer-cell-label ${layer}-label`}
    >
      {name}
    </Tooltip>
  )
}

const GeoLayerCell = ({ id, layer, name, points }: GeoLayerCellProps) => {
  console.log('GeoLayerCell', points);
  return (
    <MapSelectionContext.Consumer>
      {({selectedObject, setSelectedObject}) => {
        return (
          <GeoJSON
            data={points}
            eventHandlers={{
              click: (e) => {
                console.log('GeoLayerCell#click', layer, name, points, e)
                if (setSelectedObject) {
                  setSelectedObject({[layer]: {id: id}})
                }
                return false;
              }
            }}
          >
            <GeoLayerLabel layer={layer} name={name}/>
          </GeoJSON>
        )
      }}
    </MapSelectionContext.Consumer>

  )
}

// const GeoLayerCell = (props) => {
//   console.log('GeoLayerCell', props)
//   return html.tag(GeoJSON, 'geojson', {
//     style: { color: 'green', ...(coalesce(props.pathOptions, {})) },
//     data: props.points.points, // {type: "MultiPolygon", coordinates:[[[[2863.8983946240005, 3696.2286766321745], [2861.6281620480004, 3696.2286766321745], [2860.4930457600003, 3698.1947557154895], [2861.6281620480004, 3700.1608347988044], [2860.4930457600003, 3702.1269138821194], [2861.6281620480004, 3704.0929929654344], [2863.8983946240005, 3704.0929929654344], [2865.033510912, 3702.1269138821194], [2863.8983946240005, 3700.1608347988044], [2865.033510912, 3698.1947557154895], [2863.8983946240005, 3696.2286766321745]]], [[[2867.3037434880007, 3706.0590720487494], [2868.4388597760003, 3704.0929929654344], [2867.3037434880007, 3702.1269138821194], [2865.0335109120006, 3702.1269138821194], [2863.8983946240005, 3704.0929929654344], [2865.0335109120006, 3706.0590720487494], [2867.3037434880007, 3706.0590720487494]]]]},
//     eventHandlers: {
//       click: (e) => console.log('GeoLayerCell#click', props, e),
//       mouseover: (e) => console.log('GeoLayerCell#mouseover', props, e)
//     }
//   })
//   // return html.tag(Polygon, 'h', {
//   //   pathOptions: {color: props.color, ...(coalesce(props.pathOptions, {}))},
//   //   positions: props.points,
//   //   eventHandlers: {
//   //     click: (e) => console.log('click', props, e)
//   //   }
//   // });
// }

export default GeoLayerCell
