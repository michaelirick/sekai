import { Model } from './model'

type HexProps = {
  id?: number;
  title: string;
  x: number;
  y: number;
  parent_id: number;
  parent_type: string;
  world_id: number;
}

export class Hex extends Model {
  constructor (props: HexProps) {
    super()
    Object.assign(this, props);
    this.type = 'Hex';
  }

  static HEX_RADIUS = 6.0469;

  static endpointPrefix () {
    return '/admin/hexes';
  }

  static model_name () {
    return 'hex';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        console.log('Hex#load', data)
        return new Hex(data)
      })
  }




}
