import { extendHex } from 'honeycomb-grid'
import { Model } from './model'

type WorldProps = {
  hexSize: number;
  circumference: number;
  width: number;
}

export class World extends Model {
  constructor (props) {
    super()
    console.log('world#new', props)
    Object.assign(this, props)
    this.type = 'World'
  }

  static endpointPrefix(): string {
    return '/admins/worlds'
  }

  static model_name () {
    return 'world'
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
    .then(data => {return new this(data)})
  }

  // TODO: move to DB
  get width () {
    return this.resolution_x
  }

  // TODO: move to DB
  get hexSize () {
    return this.hex_radius
  }

  latLngToXY (latLng) {
    return [latLng.lng, latLng.lat];
  }

  pointToHex (center) {
    const [x, y] = center;
    const q = Math.round(((2.0/3) * x) / this.hexSize);
    const r = Math.round(((-1.0/3 * x + Math.sqrt(3)/3 * y) / this.hexSize));
    const ny = r + (q - (q & 1)) / 2

    return [q, ny];
  }

  hexToPoint (center) {
    const [x, y] = center;
    const nx = this.hexSize * x * 3.0/2
    const ny = this.hexSize * Math.sqrt(3) * (y + 0.5 * (x & 1))

    return [nx, ny];
  }

  drawHex (center) {
    const [x, y] = center;
    const sides = [0, 1, 2, 3, 4, 5];
    const grade = 2.0 * Math.PI / 6;

    return sides.map(s => {
      return [
        (Math.cos(grade * s) * this.hexSize) + x,
        (Math.sin(grade * s) * this.hexSize) + y
      ]
    })
  }

  hexOptions () {
    return {
      size: this.hexSize,
      strokeWidth: 1
    }
  }

  hexFactory () {
  // width of 12 mi gives side 6.9282
  // 6.9282 / (25000/8192)
    return extendHex(this.hexOptions())
  }
}
