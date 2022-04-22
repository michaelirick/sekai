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
    return '/admin/hexes/';
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

  static latLngToXY (latLng) {
    return [latLng.lng, latLng.lat];
  }

  static pointToHex (center) {
    const [x, y] = center;
    const q = Math.round(((2.0/3) * x) / Hex.HEX_RADIUS);
    const r = Math.round(((-1.0/3 * x + Math.sqrt(3)/3 * y) / Hex.HEX_RADIUS));
    const ny = r + (q - (q & 1)) / 2

    return [q, ny];
  }

  static hexToPoint (center) {
    const [x, y] = center;
    const nx = Hex.HEX_RADIUS * x * 3.0/2
    const ny = Hex.HEX_RADIUS * Math.sqrt(3) * (y + 0.5 * (x & 1))

    return [nx, ny];
  }

  static drawHex (center) {
    const [x, y] = center;
    const sides = [0, 1, 2, 3, 4, 5];
    const grade = 2.0 * Math.PI / 6;

    return sides.map(s => {
      return [
        (Math.cos(grade * s) * Hex.HEX_RADIUS) + x,
        (Math.sin(grade * s) * Hex.HEX_RADIUS) + y
      ]
    })
  }
}
