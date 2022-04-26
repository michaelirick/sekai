import { Model } from './model'

export class Biome extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Biome';
  }

  static endpointPrefix () {
    return '/admin/biomes';
  }

  static model_name () {
    return 'biome';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
