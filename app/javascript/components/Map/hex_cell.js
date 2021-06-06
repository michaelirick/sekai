import {Polygon} from 'react-leaflet'
import html from 'utils/html'
import {extendHex, Point} from 'honeycomb-grid'

const HexCell = (props) => {
  // console.log('HexCell', props)
  let point = props.hex.toPoint();
  if (props.originPoint)
    point = point.add(Point(props.originPoint))
  const hex = extendHex({
    ...props.options
  })(point.x, point.y);

  const corners = hex.corners().map((pp) => {
    const p = pp.add(point)
    return [p.y, p.x];
  });

  return html.tag(Polygon, 't', {
    pathOptions: {color: 'red'},
    positions: corners
  });
}

export default HexCell;