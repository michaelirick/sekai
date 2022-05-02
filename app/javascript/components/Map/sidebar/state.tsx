import * as React from 'react'
import { useContext, useEffect, useState } from 'react'
import api from 'utils/api'
import { Grid, Form, Button } from 'semantic-ui-react'
import { State } from 'models/state'
import { MapToolContext, MapSelectionContext } from '../map_context'
import AsyncSelect from 'react-select/async'
import { getOptionLabel } from 'react-select/dist/declarations/src/builtins'

export type StateProps = {
  id: number;
  parent_id?: number;
  parent_type?: string;
};


export const StateShow = (props: StateProps) => {

  const {setMapTool} = useContext(MapToolContext);
  const {selectedObject, setSelectedObject} = useContext(MapSelectionContext);
  const [state, setState] = useState(selectedObject);
  console.log('HexShow#hex', selectedObject)


  useEffect(() => loadState(), [selectedObject.id])

  const loadState = (params) => {
    console.log('loadHexes', props)

    State.load(selectedObject.id).then(loaded => {
      console.log('loaded', loaded)
      setSelectedObject(selectedObject)
      setState(loaded)
    })
    // if (subscription) {
    //   subscription.yo({})
    //   // subscription.perform('yo', {query: hexQuery()})
    //   // cable.send({command: 'message', action: 'yo', data: JSON.stringify({query: hexQuery()})})
    // }
    // cable.send({query: '{hex{name}}'})
    // cable.
    // cable.perform('execute', { query: '{ hex { name } }' })
    // api.get(`/admin/hexes/${hex.id}.json`, {
    //
    // }).then(response => response.json())
    //   .then((newHexes) => {
    //     console.log('loadHex#result', newHexes)
    //     setHex(newHexes)
    //   }).catch(error => {
    //   console.error('There has been a problem with your fetch operation:', error)
    // })
  }

  return (
    <Grid divided="vertically">
      <Grid.Row>
        <Grid.Column><h3>[{selectedObject?.id}] {selectedObject?.title}</h3></Grid.Column>
      </Grid.Row>
      <Grid.Row>
      </Grid.Row>
      <Grid.Row>
        <Grid.Column><Button onClick={() => setMapTool('selectDeJure')}>Set De Jure</Button></Grid.Column>
      </Grid.Row>
    </Grid>
  )

};
