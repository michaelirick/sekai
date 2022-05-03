import { Model } from './model'
import api from 'utils/api'

export class State extends Model {
  constructor (props) {
    super()
    Object.assign(this, props);
    this.type = 'State';
  }

  static endpointPrefix () {
    return '/admin/states';
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

  claimHexes(points) {
    return api.post('/admin/states/' + this.id + '/claim.json', {points: points})
  }

}
