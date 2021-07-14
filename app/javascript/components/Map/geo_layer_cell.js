import {Polygon, Popup} from 'react-leaflet'
import html from 'utils/html'
import coalesce from 'utils/coalesce'

const GeoLayerCell = (props) => {
  console.log('GeoLayerCell', props);
  return html.tag(Polygon, 'h', {
    pathOptions: {color: props.color, ...(coalesce(props.pathOptions, {}))},
    positions: props.points,
    eventHandlers: {
      click: (e) => console.log('click', props, e)
    }
  });
}

export default GeoLayerCell;