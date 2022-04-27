import * as React from 'react'
import { SelectableObjectTypesByMode } from 'models/selectable_object'
import { useContext, useEffect, useState } from 'react'
import { MapModeContext, MapSelectionContext, MapToolContext } from '../map_context'
import { Menu, Table, Button } from 'semantic-ui-react'
import api from 'utils/api'

export const Find = (props) => {
  const mapSelection = useContext(MapSelectionContext)
  const mapMode = useContext(MapModeContext)
  const mapTool = useContext(MapToolContext)
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(1)
  const [rows, setRows] = useState([])

  useEffect(() => {
    loadRows()
  }, [page, mapMode.mapMode])

  const loadRows = () => {
    const model = SelectableObjectTypesByMode[mapMode.mapMode]
    if (model) {
      model.list({ page: page, per_page: 10 })
        .then(newRows => newRows.map((row) => {
          return (new model(row));
        }))
        .then(newRows => setRows(newRows))
        .catch(error => console.log('loadRow error', error))
      model.pages({ page: page, per_page: 10 })
        .then(pages => {
          setTotal(pages.total)
        })
        .catch(error => console.log('error', error))
    }
  }

  const isActiveRow = (row) => {
    if (!mapSelection.selectedObject) {
      return false;
    }

    return mapSelection.selectedObject.id === row.id && mapSelection.selectedObject.type === row.type
  }

  const addNew = () => {
    const model = SelectableObjectTypesByMode[mapMode.mapMode]
    if (model) {
      const newJunt = new model({
        world_id: mapSelection.world.id,
        parent_type: 'World',
        parent_id: mapSelection.world.id
      })
      newJunt.save()
        .then(res => console.log('saved', res))
        .then(res => loadRows())
        .catch(error => console.log(error))
    }
    
  }

  return (
    <Table>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell colSpan='3'>
            <Button icon="plus" onClick={() => addNew()}/>
          </Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {rows.map((row) => {
          return (
            <Table.Row
              key={row.id}
              active={isActiveRow(row)}
              onClick={() => mapSelection.setSelectedObject(row)}
            >
              <Table.Cell>{row.id}</Table.Cell>
              <Table.Cell>{row.title}</Table.Cell>
              <Table.Cell>{row.color}</Table.Cell>
            </Table.Row>
          )
        })}
      </Table.Body>
      <Table.Footer>
        <Table.Row>
          <Table.HeaderCell colSpan='3'>
            <Menu floated="right" pagination>
              {page > 1 && <Menu.Item as="a" icon="chevron left" onClick={() => setPage(page - 1)}/>}
              <Menu.Item active={page === 1} as="a" onClick={() => setPage(1)}>1</Menu.Item>
              {page > 1 && page < total && <Menu.Item active as="a">{page}</Menu.Item>}
              {total > 1 && <Menu.Item active={page === total} as="a" onClick={() => setPage(total)}>{total}</Menu.Item>}
              {page < total && <Menu.Item as="a" icon="chevron right" onClick={() => setPage(page + 1)}/>}
            </Menu>
          </Table.HeaderCell>
        </Table.Row>
      </Table.Footer>
    </Table>
  );
}
