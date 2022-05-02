import { Model } from './model'

export class Subcontinent extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'Subcontinent';
  }

  static endpointPrefix () {
    return '/admin/subcontinents';
  }

  static model_name () {
    return 'subcontinent';
  }

  static load (id) {
    return Model.load(this.endpointPrefix(), id)
      .then(data => {
        return new this(data)
      })
  }

}
