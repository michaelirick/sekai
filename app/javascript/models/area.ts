import { Model } from './model'

export class Area extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Area';
  }

  static endpointPrefix () {
    return '/admin/areas/';
  }

  static model_name () {
    return 'area';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
