import {LayerGroup} from 'react-leaflet'
import html from 'utils/html'
import GeoLayerCell from './geo_layer_cell'

const GeoLayer = (props) => {
  console.log('GeoLayer', props)
  const shapes = () => {
    return props.points.map((m, i) => {
      console.log('GeoLayer#shapes', m);
      return html.tag(GeoLayerCell, i, {points: m, color: '#ff0000'});
    })
  }

  return html.tag(LayerGroup, 'layer', {}, shapes());
}

export default GeoLayer;