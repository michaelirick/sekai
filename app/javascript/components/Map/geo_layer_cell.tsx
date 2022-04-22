// eslint-disable-next-line no-use-before-define
import * as React from 'react'
import { GeoJSON, Popup, Tooltip } from 'react-leaflet'
import { MapSelectionContext, MapToolContext } from './map_context'

import './geo_layer_cell.css'
import { useContext } from 'react'
import { Hex } from '../../models/hex'

const GeoLayerTypes = {
  Hex: Hex
}

export type GeoLayerCellProps = {
  id: number;
  name: string;
  pathOptions?: unknown;
  points: [];
  color?: string;
  layer: string;
  showLabel: boolean;
}

type TooltipProps = {
  name: string;
  layer: string;
  id: number;
  show: boolean
}

const GeoLayerLabel = ({ id, name, layer, show }: TooltipProps) => {
  return (
    <Tooltip
      permanent={show}
      direction='center'
      className={`geo-layer-cell-label ${layer}-label`}
      opacity={1}
    >
      {`[${id}] ${name}`}
    </Tooltip>
  )
}

const GeoLayerCell = ({ id, type, layer, name, points, color, showLabel }: GeoLayerCellProps) => {
  const {mapTool, setMapTool} = useContext(MapToolContext);
  // console.log('GeoLayerCell', id, type, layer, name, points);
  return (
    <MapSelectionContext.Consumer>
      {({selectedObject, setSelectedObject}) => {
        const isThisSelected = selectedObject && selectedObject?.id === id && selectedObject?.type === type
        return (
          <GeoJSON
            data={points}
            pathOptions={{
              color: isThisSelected ? 'yellow' : 'black',
              fillColor: color
            }}
            eventHandlers={{
              click: (e) => {
                if (mapTool === 'select') {
                  console.log('GeoLayerCell#select', layer, id, name, points, e)
                  // e.preventDefault()
                  if (setSelectedObject) {
                    setSelectedObject(new GeoLayerTypes[type]({
                      layer: layer,
                      type: type,
                      id: id,
                      title: name,
                      type: type
                    }))
                  }
                }
                if (mapTool == 'delete') {
                  (new GeoLayerTypes[type]({type: type, id: id})).delete()
                    .then(response => console.log('deleted', response))
                    .catch(error => console.log('failed to delete', error))
                }
                if (mapTool === 'selectParent') {
                  selectedObject.parent_id = id;
                  selectedObject.parent_type = 'GeoLayer';
                  console.log('selectParent', selectedObject)
                  setSelectedObject(selectedObject);
                  selectedObject.save().then(response => console.log('saved'))
                    .catch(error => console.log('selectParent Error:', error))
                  setMapTool('select');
                }
              }
            }}
          >
            <GeoLayerLabel id={id} layer={layer} name={name} show={showLabel} />
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
