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

  save () {
    let endpoint = this.constructor.endpointPrefix() ;
    if (this.id) {
      endpoint = endpoint + this.id + '.json'
    } else {
      endpoint = endpoint + ''
    }

    return api.put(endpoint, { [this.constructor.model_name()]: this });
  }
}
