import {extendHex, defineGrid} from 'honeycomb-grid'
import {useState, useEffect} from 'react'
import {LayerGroup, Polygon, useMapEvents} from 'react-leaflet'
import html from 'utils/html'
import HexCell from './hex_cell'
import api from 'utils/api'

// width of 12 mi gives side 6.9282
// 6.9282 / (25000/8192)
const hexOptions = {
  size: 6.9282 / (25000/8192),
  strokeWidth: 1
}

const gridOptions  = {
  width: 64,
  height: 48
};

const HexFactory = extendHex(hexOptions);
const Grid = defineGrid(HexFactory);

const HexGrid = (props) => {
  const [grid, setGrid] = useState(Grid()); // empty grid, make api call to populate from center and zoom
  const [center, setCenter] = useState(HexFactory().fromPoint(props.center)); // these are point cords
  const [zoom, setZoom] = useState(props.zoom);
  const map = useMapEvents({
    click: (e) => {
      console.log('HexGrid#click', e);
    },
    zoomend: (e, z) => {
      console.log('zoomend', e, map)
      setZoom(e.target._zoom);
      loadHexes();
    },
    dragend: (e) => {
      const c = map.getCenter();
      setCenter(HexFactory().fromPoint([c.lng, c.lat]));
      loadHexes();
    }
  });
  useEffect(() => loadHexes(), {});
  // console.log('HexGrid', props, grid)

  const loadHexes = (params) => {
    api.get('/admin/hexes/map', {
      center: center,
      zoom: zoom
    }).then(response => response.json())
    .then((newHexes) => {
      setGrid(Grid(newHexes.map((h) => HexFactory(h.x, h.y))));
    }).catch(error => {
    console.error('There has been a problem with your fetch operation:', error);
  });
  }

  const hexes = () => {
    // console.log('hexes', zoom, center)
    return grid.map((h, i) => {
      return html.tag(HexCell, i, {
        hex: h,
        options: hexOptions
      });
    });
  }

  return html.tag(LayerGroup, 'hexes', {},
    hexes()
  );
}

export default HexGrid;
