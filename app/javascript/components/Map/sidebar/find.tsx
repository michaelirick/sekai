import * as React from 'react'
import { SelectableObjectTypesByMode } from 'models/selectable_object'
import { useContext, useEffect, useState } from 'react'
import { MapModeContext, MapSelectionContext, MapToolContext, MapViewContext } from '../map_context'
import { Menu, Table, Button, Input, Loader, Dimmer } from 'semantic-ui-react'
import api from 'utils/api'
import { Hex } from '../../../models/hex'

export const Find = (props) => {
  const mapView = useContext(MapViewContext)
  const mapSelection = useContext(MapSelectionContext)
  const mapMode = useContext(MapModeContext)
  const mapTool = useContext(MapToolContext)
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(1)
  const [rows, setRows] = useState([])
  const [searchId, setSearchId] = useState('')
  const [searchTitle, setSearchTitle] = useState('')
  const [searchColor, setSearchColor] = useState('')
  const [sortColumn, setSortColumn] = useState('id')
  const [sortDirection, setSortDirection] = useState('asc')
  const [loadingRows, setLoadingRows] = useState(true)
  const [loadingPages, setLoadingPages] = useState(true)

  useEffect(() => {
    loadRows()
  }, [
    page,
    mapMode.mapMode,
    searchId,
    searchTitle,
    searchColor,
    sortColumn,
    sortDirection
  ])

  const loadRows = () => {
    const model = SelectableObjectTypesByMode[mapMode.mapMode]
    if (model) {
      //q%5Btitle_contains%5D=test
      const filterParams = {
        page: page,
        per_page: 10,
        'q[id]': searchId,
        'q[title_contains]': searchTitle,
        'q[color_contains]': searchColor,
        order: `${sortColumn}_${sortDirection}`
        // q: {
        //   id_contains: searchId,
        //   title_contains: searchTitle,
        //   color_contains: searchColor
        // }
      }
      setLoadingRows(true)
      setLoadingPages(true)
      model.list(filterParams)
        .then(newRows => newRows.map((row) => {
          return (new model(row));
        }))
        .then(newRows => {
          setLoadingRows(false)
          setRows(newRows)
        })
        .catch(error => console.log('loadRow error', error))
      model.pages(filterParams)
        .then(pages => {
          console.log('pages', pages)
          setTotal(pages.total)
          setLoadingPages(false)
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

  const setObject = (object) => {
    console.log('setObject', object)
    mapSelection.setSelectedObject(object)
    if (object.type === 'Hex') {
      mapView.updateMapCenter(mapView.map, ...(Hex.hexToPoint([object.x, object.y])))
    }
  }

  const LoadingRow = (props) => {
    console.log('loadingRow')
    return (
      <Table.Row>
        <Table.Cell colSpan='3'>
          <Loader active/>
        </Table.Cell>
      </Table.Row>
    )
  }

  const isSorted = (column) => {
    if (sortColumn !== column)
      return null;

    return sortDirection === 'asc' ? 'ascending' : 'descending'
  }

  const onSort = (column) => {
    if (column !== sortColumn)
      setSortColumn(column)
    else {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc')
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
        <Table.Row>
          <Table.HeaderCell sorted={isSorted('id')}>
            <h3 onClick={() => onSort('id')}>ID</h3>
            {/* <Input value={searchId} onChange={(e) => setSearchId(e.target.value)}/> */}
          </Table.HeaderCell>
          <Table.HeaderCell>
            <Input value={searchTitle} onChange={(e) => setSearchTitle(e.target.value)}/>
          </Table.HeaderCell>
          <Table.HeaderCell>
            <Input value={searchColor} onChange={(e) => setSearchColor(e.target.value)}/>
          </Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {loadingRows ? <LoadingRow/> : rows.map((row) => {
          return (
            <Table.Row
              key={row.id}
              active={isActiveRow(row)}
              onClick={() => setObject(row)}
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
            {loadingPages ? <Loader/> :
            <Menu floated="right" pagination>
              {page > 1 && <Menu.Item as="a" icon="chevron left" onClick={() => setPage(page - 1)}/>}
              <Menu.Item active={page === 1} as="a" onClick={() => setPage(1)}>1</Menu.Item>
              {page > 1 && page < total && <Menu.Item active as="a">{page}</Menu.Item>}
              {total > 1 && <Menu.Item active={page === total} as="a" onClick={() => setPage(total)}>{total}</Menu.Item>}
              {page < total && <Menu.Item as="a" icon="chevron right" onClick={() => setPage(page + 1)}/>}
            </Menu>}
          </Table.HeaderCell>
        </Table.Row>
      </Table.Footer>
    </Table>
  );
}
