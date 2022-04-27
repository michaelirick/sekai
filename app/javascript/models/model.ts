import api from 'utils/api'

type ModelProps = {
  id?: number;
}

export class Model {
  constructor (props: ModelProps) {
    Object.assign(this, props);
  }

  static endpointPrefix () {
    return '';
  }

  static load (endpoint, id) {
    return api.get(endpoint + '/' + id + '.json')
      .then(response => response.json())
  }

  reload () {
    return api.get(this.constructor.endpointPrefix() + this.id + '.json')
      .then(response => response.json())
      .then(data => Object.assign(this, data))
  }

  updateGeometry (points) {
    let endpoint = this.constructor.endpointPrefix() ;
    if (this.id) {
      endpoint = endpoint + '/' + this.id + '/update_boundaries.json'
    }

    return api.post(endpoint, { points: points });
  }

  static list (params) {
    return api.get(this.endpointPrefix() + '.json', params)
      .then(response => response.json())
  }

  static pages (params) {
    return api.get(this.endpointPrefix() + '/pages.json', params)
      .then(response => response.json())
  }

  save () {
    let endpoint = this.constructor.endpointPrefix() ;
    let method = 'put'
    if (this.id) {
      endpoint = endpoint + '/' + this.id + '.json'
    } else {
      endpoint = endpoint + ''
      method = 'post'
    }

    return api[method](endpoint, { [this.constructor.model_name()]: this });
  }

  delete () {
    return api.delete(this.constructor.endpointPrefix() + this.id + '.json')
  }
}
