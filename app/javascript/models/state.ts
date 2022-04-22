import { Model } from './model'

export class State extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'State';
  }

  static endpointPrefix () {
    return '/admin/states/';
  }

  static model_name () {
    return 'state';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
