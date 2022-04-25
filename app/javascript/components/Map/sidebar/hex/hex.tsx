import * as React from 'react'
import { useContext, useEffect, useState } from 'react'
import api from 'utils/api'
import { Grid, Form, Button } from 'semantic-ui-react'
import { Hex } from 'models/hex'
import { MapToolContext, MapSelectionContext } from '../../map_context'
import AsyncSelect from 'react-select/async'
import { getOptionLabel } from 'react-select/dist/declarations/src/builtins'

export type HexProps = {
  id: number;
  parent_id?: number;
  parent_type?: string;
};

const useForm = (object, update, fields = {}) => {
  // const [object, setObject] = useState(m);
  console.log('useForm', object, update)
  const inputFor = (t) => {
    if (!object) {
      return '';
    }

    if (fields[t]) {
      if (fields[t].type === 'react-select') {
        console.log('react-select', t, fields[t], object, object[t])
        return (
          <AsyncSelect
            cacheOptions
            defaultOptions
            value={object[t]}
            inputValue={object[`${t}_label`] || object[t]}
            loadOptions={fields[t].loadOptions}
            onInputChange={value => {
              console.log('onInputChange', value)
              update(new (object.constructor)({
                ...object,
                [`${t}_label`]: value
              }))
            }}
            onChange={(value) => {
              console.log('onChange', value)
              update(new (object.constructor)({
                ...object,
                [t]: value.value
              }))
            }}
          />
        );
      }
    }

    if (t === 'submit') {
      return (
        <Button
          type="submit"
          onClick={(e) => {
            object.save()
              .then((response) => {
                console.log('saved', response)
              })
              .catch(error => console.log('error:', error))
          }}
        >Submit</Button>
      )
    }

    return (
      <Form.Input
        label={t}
        value={object[t] ? object[t] : ''}
        onChange={(e) => {
          console.log('update', t, object, e.target.value);
          // object[t] = e.target.value;
          update(new (object.constructor)({...object, [t]: e.target.value}))
        }}
        />
    )
  }

  const withLayout = (fieldsForLayout) => {
    return (
      <Form>
        {fieldsForLayout.map((field) => {
          return inputFor(field)
        })}
      </Form>
    )
  }

  return {inputFor, withLayout};
}

export const HexShow = (props: HexProps) => {

  const {setMapTool} = useContext(MapToolContext);
  const {selectedObject, setSelectedObject} = useContext(MapSelectionContext);
  const [hex, setHex] = useState(selectedObject);
  console.log('HexShow#hex', selectedObject)
  const hexForm = useForm(hex, setHex, {
    biome: {
      type: 'react-select',
      loadOptions: () => {
        return fetch('/admin/hexes/biomes').then(response => response.json()).then(options => {
          console.log('biomes', options)
          return options;
        });
      },
      getOptionLabel: e => e.label,
      getOptionValue: e => e.value
    }
  });

  useEffect(() => loadHex(), [selectedObject.id])

  const loadHex = (params) => {
    console.log('loadHexes', props)

    Hex.load(selectedObject.id).then(loadedHex => {
      console.log('loaded', loadedHex)
      setSelectedObject(selectedObject)
      setHex(loadedHex)
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
        <Grid.Column><h3>[{selectedObject?.id}] {selectedObject?.title} ({selectedObject?.x}, {selectedObject?.y})</h3></Grid.Column>
      </Grid.Row>
      <Grid.Row>
        <Grid.Column>{hexForm.withLayout(['title', 'parent_id', 'parent_type', 'owner_id', 'owner_type', 'submit'])}</Grid.Column>
      </Grid.Row>
      <Grid.Row>
        <Grid.Column><Button onClick={() => setMapTool('selectParent')}>Set Parent</Button></Grid.Column>
      </Grid.Row>
    </Grid>
  )

};
