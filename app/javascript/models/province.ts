import { Model } from './model'

export class Province extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Province';
  }

  static endpointPrefix () {
    return '/admin/provinces/';
  }

  static model_name () {
    return 'province';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        console.log('Province#load', data)
        return new this(data)
      })
  }

}
