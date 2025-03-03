import { Polygon, Popup } from 'react-leaflet'
import html from 'utils/html'
import { extendHex, Point } from 'honeycomb-grid'
import HexInfo from './hex_info'
import coalesce from 'utils/coalesce'

const HexCell = (props) => {
  // console.log('HexCell', props)
  const point = props.hex.toPoint()

  const hex = extendHex({
    ...props.options
  })(point.x, point.y)

  const corners = hex.corners().map((pp) => {
    const p = pp.add(point)
    return [p.x, p.y]
  })

  const content = () => {
    return html.tag(HexInfo, 'info', { hex: props.hex, points: corners })
  }

  const popup = () => {
    return html.tag(Popup, 'popup', {

    }, content())
  }

  // idk

  return html.tag(Polygon, 't', {
    pathOptions: { color: props.hex.color, ...(coalesce(props.pathOptions, {})) },
    positions: corners,
    eventHandlers: {
      click: (e) => console.log('HexCell#click', props, e)
    }
  })
}

export default HexCell
