const api = {}

function encodeQueryString (params) {
  const keys = Object.keys(params)
  return keys.length
    ? '?' + keys
      .map(key => encodeURIComponent(key) +
                '=' + encodeURIComponent(params[key]))
      .join('&')
    : ''
}

api.post = (url, params, options) => {
  return fetch(url, {
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
    },
    method: 'POST',
    body: JSON.stringify(params)
  })
}

api.put = (url, params, options) => {
  return fetch(url, {
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
    },
    method: 'PUT',
    body: JSON.stringify(params)
  })
}

api.get = (url, params, options) => {
  console.log('get', url)
  return fetch(`${url}${encodeQueryString(params)}`)
}

export default api
