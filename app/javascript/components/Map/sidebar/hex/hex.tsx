import * as React from 'react'
import { useEffect, useState } from 'react'
import api from 'utils/api'
import { Grid } from 'semantic-ui-react'

export type HexProps = {
  id: number;
};

export const Hex = (props: HexProps) => {
  const [hex, setHex] = useState({ id: props.id, ...props });
  const [x, setX] = useState();
  const [y, setY] = useState();

  useEffect(() => loadHex(), [])

  const loadHex = (params) => {
    console.log('loadHexes', props)
    // if (subscription) {
    //   subscription.yo({})
    //   // subscription.perform('yo', {query: hexQuery()})
    //   // cable.send({command: 'message', action: 'yo', data: JSON.stringify({query: hexQuery()})})
    // }
    // cable.send({query: '{hex{name}}'})
    // cable.
    // cable.perform('execute', { query: '{ hex { name } }' })
    api.get(`/admin/hexes/${hex.id}.json`, {

    }).then(response => response.json())
      .then((newHexes) => {
        console.log('loadHex#result', newHexes)
        setHex(newHexes)
      }).catch(error => {
      console.error('There has been a problem with your fetch operation:', error)
    })
  }
  const updateHex = () => {
    api.put(`/admin/hexes/${hex.id}.json`, {
      x: x
    });
  }

  return (
    <Grid divided="vertically">
      <Grid.Row>
        <Grid.Column><h3>{hex.title}</h3></Grid.Column>
      </Grid.Row>
    </Grid>
  )

};
