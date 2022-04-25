import { Model } from './model'

export class Settlement extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Settlement';
  }

  static endpointPrefix () {
    return '/admin/settlements/';
  }

  static model_name () {
    return 'settlement';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
