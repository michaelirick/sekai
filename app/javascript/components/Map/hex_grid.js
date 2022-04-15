import { extendHex, defineGrid } from 'honeycomb-grid'
import { useState, useEffect, useCallback } from 'react'
import { LayerGroup, Polygon, useMapEvents } from 'react-leaflet'
import html from 'utils/html'
import HexCell from './hex_cell'
import api from 'utils/api'
import World from 'models/world'
import ActionCable from 'actioncable'

const HexGrid = (props) => {
  const world = new World(props.world)
  const gridOptions = {
    width: 64,
    height: 48
  }

  const HexFactory = world.hexFactory()
  const Grid = defineGrid(HexFactory)

  const [grid, setGrid] = useState(Grid()) // empty grid, make api call to populate from center and zoom
  const [center, setCenter] = useState(HexFactory().fromPoint(props.center)) // these are point cords
  const [zoom, setZoom] = useState(props.zoom)
  const [selectedHex, setSelectedHex] = useState(null)
  const [cable, setCable] = useState(ActionCable.createConsumer('/cable'))
  const [subscription, setSubscription] = useState(null);

  const map = useMapEvents({
    click: (e) => {
      console.log('HexGrid#click', e)
      selectBlankHex(e, map)
    },
    zoomend: (e, z) => {
      console.log('zoomend', e.target._zoom, e, z, map)
      setZoom(e.target._zoom)
      localStorage.setItem('mapZoom', e.target._zoom)
      // loadHexes()
    },
    dragend: (e) => {
      const c = map.getCenter()
      setCenter(HexFactory().fromPoint([c.lng, c.lat]))
      localStorage.setItem('mapCenterX', c.lng)
      localStorage.setItem('mapCenterY', c.lat)
      // loadHexes()
    }
  })
  useEffect(() => loadHexes(), [])
  useEffect(() => loadHexes(), [center, zoom])
  useEffect(() => initCable(), [])
  useEffect(() => refreshGrid(), [selectedHex])
  // console.log('HexGrid', props, grid)

  const initCable = () => {
    setSubscription(cable.subscriptions.create(
      { channel: 'GraphqlChannel', test: 'yo?' }, {
        // execute(data) {
        //   console.log('cable#execute', data)
        // },

        received (data) {
          console.log('cable#received', data)
          console.log('result', data.result)
          refreshGrid(data.result.data.hex)
        },

        yo (data) {
          console.log('yo', data)
          console.log('center', center)
          console.log('zoom', zoom)
          this.perform('execute', {query: hexQuery()})
        }
      }
    ))

    // s.perform('yo', {query: hexQuery() })
    // cable.send({test: 'yeet'})
  }

  const hexQuery = () => {
    return `{ hex(worldId: ${world.id}, x: ${center.x}, y: ${center.y}, zoom: ${zoom}) { title x y id } }`
  }

  const selectBlankHex = (e, map) => {
    setSelectedHex(HexFactory().fromPoint([e.latlng.lat, e.latlng.lng]))
    loadHexes()
    console.log('selectBlankHex', e, map)
  }

  const refreshGrid = (newHexes = []) => {
    // cable.send({test: 'yeet'})
    // console.log('refreshGrid', cable)
    const newGrid = Grid([
      HexFactory(selectedHex, { color: 'blue', world_id: props.world.id }),
      ...newHexes.map((h) => HexFactory(h.x, h.y, { h }))
    ])
    setGrid(newGrid)
  }

  const loadHexes = (params) => {
    console.log('loadHexes', props)
    if (subscription) {
      subscription.yo({})
      // subscription.perform('yo', {query: hexQuery()})
      // cable.send({command: 'message', action: 'yo', data: JSON.stringify({query: hexQuery()})})
    }
    // cable.send({query: '{hex{name}}'})
    // cable.
    // cable.perform('execute', { query: '{ hex { name } }' })
    // api.get(`/admin/worlds/${props.world.id}/map`, {
    //   center: center,
    //   zoom: zoom
    // }).then(response => response.json())
    //   .then((newHexes) => {
    //     refreshGrid(newHexes)
    //   }).catch(error => {
    //     console.error('There has been a problem with your fetch operation:', error)
    //   })
  }

  const hexes = () => {
    // console.log('hexes', zoom, center)
    return grid.map((h, i) => {
      return html.tag(HexCell, i, {
        hex: h,
        options: world.hexOptions()
      })
    })
  }

  return html.tag(LayerGroup, 'hexes', {},
    hexes()
  )
}

export default HexGrid
