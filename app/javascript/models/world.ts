import { extendHex } from 'honeycomb-grid'

type WorldProps = {
  hexSize: number;
  circumference: number;
  width: number;
}

class World {
  constructor (props: WorldProps) {
    console.log('world#new', props)
    Object.assign(this, props)
  }

  // TODO: move to DB
  get circumference () {
    return 25000
  }

  // TODO: move to DB
  get width () {
    return 8192
  }

  // TODO: move to DB
  get hexSize () {
    return 6.0469
  }

  hexOptions () {
    return {
      size: this.hexSize / (this.circumference / this.width),
      strokeWidth: 1
    }
  }

  hexFactory () {
  // width of 12 mi gives side 6.9282
  // 6.9282 / (25000/8192)
    return extendHex(this.hexOptions())
  }
}

export default World
