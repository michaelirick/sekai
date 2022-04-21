import { extendHex, defineGrid } from 'honeycomb-grid'
import * as React from 'react'
import { useState, useEffect, useCallback, useContext } from 'react'
import { LayerGroup, Polygon, useMapEvents } from 'react-leaflet'
import html from 'utils/html'
import HexCell from './hex_cell'
import api from 'utils/api'
import World from 'models/world'
import { Hex } from 'models/hex'
import ActionCable from 'actioncable'
import { MapSelectionContext, MapToolContext } from './map_context'
import GeoLayerCell from './geo_layer_cell'

const GeoLayerGrid = (props) => {
  const {mapTool} = useContext(MapToolContext);
  const world = new World(props.world)
  const gridOptions = {
    width: 64,
    height: 48
  }

  // const HexFactory = world.hexFactory()
  // const Grid = defineGrid(HexFactory)

  const [grid, setGrid] = useState([]) // empty grid, make api call to populate from center and zoom
  const [center, setCenter] = useState(props.center ? props.center : [localStorage.getItem('mapCenterX'), localStorage.getItem('mapCenterY')]) // these are point cords
  const [zoom, setZoom] = useState(props.zoom ? props.zoom : localStorage.getItem('mapZoom'))
  const [selectedHex, setSelectedHex] = useState(null)
  // const [cable, setCable] = useState(ActionCable.createConsumer('/cable'))
  // const [subscription, setSubscription] = useState(null);

  const map = useMapEvents({
    click: (e) => {
      if (mapTool === 'add') {
        console.log('GeoLayerGrid#add', e)
        const [x, y] = Hex.pointToHex(Hex.latLngToXY(e.latlng))
        api.post('/admin/hexes.json', {
          hex: {
            world_id: world.id,
            x: x,
            y: y,
            parent_id: world.id,
            parent_type: 'World'
          }
        }).then(() => loadHexes())
      }
      // console.log('HexGrid#click', e)
      // // selectBlankHex(e, map)
      // if (props.selectedObject) {
      //   if (props.selectedObject?.blank_hex) {
      //     console.log('click prev-blank', props.selectedObject)
      //   } else {
      //     console.log('click prev-non-blank', props.selectedObject)
      //   }
      // } else {
      //   selectBlankHex(e, map);
      // }
    },
    zoomend: (e, z) => {
      console.log('zoomend', e.target._zoom, e, z, map)
      setZoom(e.target._zoom)
      localStorage.setItem('mapZoom', e.target._zoom)
      // loadHexes()
    },
    dragend: (e) => {
      const c = map.getCenter()
      setCenter([c.lng, c.lat])
      localStorage.setItem('mapCenterX', c.lng)
      localStorage.setItem('mapCenterY', c.lat)
      // loadHexes()
      console.log('dragend', e, [c.lng, c.lat])
    }
  })
  useEffect(() => loadHexes(), [])
  useEffect(() => loadHexes(), [center, zoom, props.mapMode])
  // useEffect(() => initCable(), [])
  // useEffect(() => refreshGrid(), [selectedHex])
  // console.log('HexGrid', props, grid)

  // const initCable = () => {
  //   setSubscription(cable.subscriptions.create(
  //     { channel: 'GraphqlChannel', test: 'yo?' }, {
  //       // execute(data) {
  //       //   console.log('cable#execute', data)
  //       // },
  //
  //       received (data) {
  //         console.log('cable#received', data)
  //         console.log('result', data.result)
  //         refreshGrid(data.result.data.hex)
  //       },
  //
  //       yo (data) {
  //         console.log('yo', data)
  //         console.log('center', center)
  //         console.log('zoom', zoom)
  //         this.perform('execute', {query: hexQuery()})
  //       }
  //     }
  //   ))
  //
  //   // s.perform('yo', {query: hexQuery() })
  //   // cable.send({test: 'yeet'})
  // }

  const hexQuery = () => {
    return '';
    // return `{ hex(worldId: ${world.id}, x: ${center.x}, y: ${center.y}, zoom: ${zoom}) { title x y id } }`
  }

  const selectBlankHex = (e, map) => {

    props.setSelectedObject({blank_hex: e.latlng});

    // loadHexes()
    // console.log('selectBlankHex', e, map)
  }

  const refreshGrid = (newHexes = []) => {
    console.log('refreshGrid', newHexes)
    setGrid(newHexes?.cells);
    // // cable.send({test: 'yeet'})
    // // console.log('refreshGrid', cable)
    // const newGrid = Grid([
    //   HexFactory(selectedHex, { color: 'red', world_id: props.world.id }),
    //   ...newHexes.map((h) => HexFactory(h.x, h.y, { h }))
    // ])
    // setGrid(newGrid)
  }

  const loadHexes = (params) => {
    // console.log('loadHexes', props)
    // if (subscription) {
    //   subscription.yo({})
    //   // subscription.perform('yo', {query: hexQuery()})
    //   // cable.send({command: 'message', action: 'yo', data: JSON.stringify({query: hexQuery()})})
    // }
    // cable.send({query: '{hex{name}}'})
    // cable.
    // cable.perform('execute', { query: '{ hex { name } }' })
    api.get(`/admin/worlds/${props.world.id}/map`, {
      center: center,
      zoom: zoom,
      mapMode: props.mapMode
    }).then(response => response.json())
      .then((newHexes) => {
        refreshGrid(newHexes)
      }).catch(error => {
        console.error('There has been a problem with your fetch operation:', error)
      })
  }

  const hexes = ({selectedObject, setSelectedObject}) => {
    // console.log('hexes', zoom, center)
    return grid.map((h, i) => {
      // console.log('cell', h);
      return <GeoLayerCell key={i} {...h}/>
      // return html.tag(HexCell, i, {
      //   hex: h,
      //   options: world.hexOptions()
      // })
    })
  }

  const selectedBlankHex = ({selectedObject}) => {
    if (!selectedObject?.blank_hex)
      return '';
    console.log('blank_hex', selectedObject)
    console.log('latLngToXY', (((Hex.latLngToXY(selectedObject.blank_hex)))))
    console.log('pointToHex', ((Hex.pointToHex(Hex.latLngToXY(selectedObject.blank_hex)))))
    console.log('hexToPoint', (Hex.hexToPoint(Hex.pointToHex(Hex.latLngToXY(selectedObject.blank_hex)))))
    console.log('drawHex', Hex.drawHex(Hex.hexToPoint(Hex.pointToHex(Hex.latLngToXY(selectedObject.blank_hex)))))
    const hex = Hex.drawHex(Hex.hexToPoint(Hex.pointToHex(Hex.latLngToXY(selectedObject.blank_hex))));
    console.log('newHex', hex);
    return <Polygon
      pathOptions={{color: 'green'}}
      positions={hex}
    />
  }

  return <MapSelectionContext.Consumer>
    {(context) => <LayerGroup>
      {hexes(context)}
      {selectedBlankHex(context)}
    </LayerGroup>}
  </MapSelectionContext.Consumer>

  // return html.tag(MapSelectionContext.Consumer, 'hexes',
  //   (
  //     ({selectedObject, setSelectedObject}) => html.tag(LayerGroup, 'hexes', {}, hexes())
  //   )
  // );


}

export default GeoLayerGrid
