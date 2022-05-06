import { extendHex, defineGrid } from 'honeycomb-grid'
import * as React from 'react'
import { useState, useEffect, useCallback, useContext } from 'react'
import { LayerGroup, Marker, Polygon, Polyline, Popup, Tooltip, useMap, useMapEvents } from 'react-leaflet'
import html from 'utils/html'
import HexCell from './hex_cell'
import api from 'utils/api'
import {World} from 'models/world'
import { Hex } from 'models/hex'
import ActionCable from 'actioncable'
import { MapSelectionContext, MapToolContext, MapModeContext, MapViewContext, useMapMode } from './map_context'
import GeoLayerCell from './geo_layer_cell'

const GeoLayerGrid = (props) => {
  const mapObject = useMap();
  const mapTool = useContext(MapToolContext);
  const mapMode = useContext(MapModeContext);
  const mapView = useContext(MapViewContext);
  const mapSelection = useContext(MapSelectionContext)
  const world = new World(props.world)
  const gridOptions = {
    width: 64,
    height: 48
  }

  if (!mapView.map) {
    mapView.setMap(mapObject)
  }

  const [grid, setGrid] = useState([]) // empty grid, make api call to populate from center and zoom
  const [center, setCenter] = useState(props.center ? props.center : [localStorage.getItem('mapCenterX'), localStorage.getItem('mapCenterY')]) // these are point cords
  const [zoom, setZoom] = useState(props.zoom ? props.zoom : localStorage.getItem('mapZoom'))


  const map = useMapEvents({
    baselayerchange: (e) => {
      console.log('baselayerchange', e)
      mapMode.setMapLayer(e.name)
      localStorage.setItem("mapLayer", e.name)
    },
    click: (e) => {
      if (mapTool.mapTool === 'add') {
        console.log('GeoLayerGrid#add', e)
        const [x, y] = mapSelection.world.pointToHex(mapSelection.world.latLngToXY(e.latlng))
        let parent_id = world.id;
        let parent_type = 'World'
        if (mapSelection.selectedObject && mapSelection.type != 'Hex') {
          parent_id = mapSelection.selectedObject.id
          parent_type = 'GeoLayer'
        }
        api.post('/admin/hexes.json', {
          hex: {
            world_id: world.id,
            x: x,
            y: y,
            parent_id: parent_id,
            parent_type: parent_type
          }
        }).then(response => response.json())
          .then(json => {
            console.log('success', json)
            loadHexes()
          })
          .catch(error => console.log('error', error))
      } else if (mapTool.mapTool === 'editPoints' || mapTool.mapTool === 'selectPoints' || mapTool.mapTool === 'measure') {
        const x = e.latlng.lng
        const y = e.latlng.lat
        mapTool.setMapToolPoints([...mapTool.mapToolPoints, [x, y]])
      } else if (mapTool.mapTool === 'placeMarker') {
        const x = e.latlng.lng
        const y = e.latlng.lat
        mapTool.setMapToolPoint([x, y])
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
      mapView.setMapZoom(e.target._zoom)
      localStorage.setItem('mapZoom', e.target._zoom)
      // loadHexes()
    },
    dragend: (e) => {
      const c = map.getCenter()
      // setCenter([c.lng, c.lat])
      mapView.setMapCenterX(c.lng)
      mapView.setMapCenterY(c.lat)
      localStorage.setItem('mapCenterX', c.lng)
      localStorage.setItem('mapCenterY', c.lat)
      // loadHexes()
      console.log('dragend', e, [c.lng, c.lat])
    },
    keyup: (e) => {
      // Escape
      if (mapTool.mapTool === 'select' && mapSelection.selectedObject && e.originalEvent.keyCode == 27) {
        mapSelection.setSelectedObject({})
        e.preventDefault()
      } else if (mapTool.mapTool === 'placeMarker') {
        mapTool.setMapToolPoint(null);
        e.preventDefault()
      } else if (mapTool.mapTool === 'editPoints') {
        mapTool.setMapToolPoints(null)
        e.preventDefault()
      }
    }
  })
  useEffect(() => loadHexes(), [])
  useEffect(() => loadHexes(), [
    mapMode.mapMode,
    mapView.mapZoom,
    mapView.mapCenterX,
    mapView.mapCenterY,
    mapTool.mapToolPoints
  ])
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
    refreshGrid({ cells: [] })
    api.get(`/admin/worlds/${props.world.id}/map`, {
      center: [mapView.mapCenterX, mapView.mapCenterY],
      zoom: mapView.mapZoom,
      mapMode: mapMode.mapMode
    }).then(response => response.json())
      .then((newHexes) => {
        refreshGrid(newHexes)
      }).catch(error => {
        console.error('There has been a problem with your fetch operation:', error)
      })
  }

  const hexes = ({selectedObject, setSelectedObject}) => {
    console.log('GeoLayerGrid#cells', zoom, center, mapMode.mapMode, mapMode.mapMode === 'hexes' && zoom > 2)
    let showLabel = true;

    if (mapMode.mapMode === 'hexes' && mapView.mapZoom < 2) {
      console.log('showLabel', mapView)
      showLabel = false;
      return ""
    }

    return grid.map((h, i) => {
      // console.log('cell', h);
      return <GeoLayerCell key={i} {...h} showLabel={showLabel}/>
      // return html.tag(HexCell, i, {
      //   hex: h,
      //   options: world.hexOptions()
      // })
    })
  }

  const toolPointMarkers = () => {
    console.log('toolPoints', mapTool.mapToolPoints)
    return mapTool.mapToolPoints.map(([x, y]) => {
      return (
        <Marker
          position={{ lat: y, lng: x }}
        />
      )
    })
  }

  const toolPointMarker = () => {
    if (!mapTool.mapToolPoint) {
      return ''
    }

    return (
      <Marker
        position={{lat: mapTool.mapToolPoint[1], lng: mapTool.mapToolPoint[0]}}
      >
        <Popup permanent>
          ({mapTool.mapToolPoint.join(', ')})
        </Popup>
      </Marker>
    )
  }

  const measureLine = () => {
    if (!mapTool.mapToolPoints) {
      return
    }
    if (mapTool.mapToolPoints && mapTool.mapToolPoints.length === 0) {
      return
    }
    if (mapTool.mapTool !== 'measure') {
      return
    }
    let points = mapTool.mapToolPoints
    console.log('points', points)

    let total = mapSelection.world.inMiles(mapSelection.world.polylineDistance(points))

    return (
      <Polyline pathOptions={{ color: 'red' }} positions={points.map(([x, y]) => ({ lat: y, lng: x }))}>
        <Tooltip permanent direction="center">{total.toFixed(2)} miles</Tooltip>
      </Polyline>
    )
  }

  console.log('messages', mapView.messages)

  return <MapSelectionContext.Consumer>
    {(context) => <LayerGroup>
      {hexes(context)}
      {toolPointMarkers()}
      {mapTool.mapTool === 'placeMarker' ? toolPointMarker() : ''}
      {mapTool.mapTool === 'measure' ? measureLine() : ''}
    </LayerGroup>}
  </MapSelectionContext.Consumer>

  // return html.tag(MapSelectionContext.Consumer, 'hexes',
  //   (
  //     ({selectedObject, setSelectedObject}) => html.tag(LayerGroup, 'hexes', {}, hexes())
  //   )
  // );


}

export default GeoLayerGrid
