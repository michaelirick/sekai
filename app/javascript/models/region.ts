import { Model } from './model'

export class Region extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Region';
  }

  static endpointPrefix () {
    return '/admin/regions/';
  }

  static model_name () {
    return 'region';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
