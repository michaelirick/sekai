import { Model } from './model'

export class Culture extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Culture';
  }

  static endpointPrefix () {
    return '/admin/cultures/';
  }

  static model_name () {
    return 'culture';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
