import {extendHex, defineGrid} from 'honeycomb-grid'
import {useState, useEffect} from 'react'
import {LayerGroup, Polygon} from 'react-leaflet'
import html from 'utils/html'
import HexCell from './hex_cell'

// width of 12 mi gives side 6.9282
// 6.9282 / (25000/8192)
const hexOptions = {
  size: 6.9282 / (25000/8192),
  strokeWidth: 1
}

const HexFactory = extendHex(hexOptions);
const Grid = defineGrid(HexFactory);

const HexGrid = (props) => {
  const [grid, setGrid] = useState(Grid.rectangle({width: 212, height: 106}));
  console.log('HexGrid', grid)
  return html.tag(LayerGroup, 'hexes', {},
    grid.map((h, i) => {
      return html.tag(HexCell, i, {hex: h, options: hexOptions});
    })
  );
}

export default HexGrid;