import { Model } from './model'

export class Continent extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Continent';
  }

  static endpointPrefix () {
    return '/admin/continents/';
  }

  static model_name () {
    return 'continent';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
