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
    return api.get(endpoint + id + '.json')
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
      endpoint = endpoint + this.id + '/update_boundaries.json'
    }

    return api.post(endpoint, { points: points });
  }

  save () {
    let endpoint = this.constructor.endpointPrefix() ;
    if (this.id) {
      endpoint = endpoint + this.id + '.json'
    } else {
      endpoint = endpoint + ''
    }

    return api.put(endpoint, { [this.constructor.model_name()]: this });
  }

  delete () {
    return api.delete(this.constructor.endpointPrefix() + this.id + '.json')
  }
}
