import { extendHex, defineGrid } from 'honeycomb-grid'
import { useState, useEffect } from 'react'
import { LayerGroup, Polygon, useMapEvents } from 'react-leaflet'
import html from 'utils/html'
import HexCell from './hex_cell'
import api from 'utils/api'
import World from 'models/world'

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
  const map = useMapEvents({
    click: (e) => {
      console.log('HexGrid#click', e)
      selectBlankHex(e, map)
    },
    zoomend: (e, z) => {
      console.log('zoomend', e, map)
      setZoom(e.target._zoom)
      loadHexes()
    },
    dragend: (e) => {
      const c = map.getCenter()
      setCenter(HexFactory().fromPoint([c.lng, c.lat]))
      loadHexes()
    }
  })
  useEffect(() => loadHexes(), [])
  useEffect(() => refreshGrid(), [selectedHex])
  // console.log('HexGrid', props, grid)

  const selectBlankHex = (e, map) => {
    setSelectedHex(HexFactory().fromPoint([e.latlng.lat, e.latlng.lng]))
    loadHexes()
    console.log('selectBlankHex', e, map)
  }

  const refreshGrid = (newHexes = []) => {
    const newGrid = Grid([
      HexFactory(selectedHex, { color: 'blue', world_id: props.world.id }),
      ...newHexes.map((h) => HexFactory(h.x, h.y, { h }))
    ])
    setGrid(newGrid)
  }

  const loadHexes = (params) => {
    console.log('loadHexes', props)
    api.get(`/admin/worlds/${props.world.id}/map`, {
      center: center,
      zoom: zoom
    }).then(response => response.json())
      .then((newHexes) => {
        refreshGrid(newHexes)
      }).catch(error => {
        console.error('There has been a problem with your fetch operation:', error)
      })
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
