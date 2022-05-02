import * as React from "react";
import { Icon, Menu, Dropdown } from 'semantic-ui-react'
import { MapModeContext, MapToolContext, MapViewContext } from './map_context'
import { useContext } from 'react'

export const ToolBar = (props) => {
  const mapTool = useContext(MapToolContext);
  const mapMode = useContext(MapModeContext);
  const mapView = useContext(MapViewContext);
  console.log('ToolBar', props)
  const MapMode = ({name, label}) => {
    return (<Menu.Item
      name={name}
      active={mapMode.mapMode === name}
      content={label}
      onClick={() => {
        localStorage.setItem('mapMode', name)
        mapMode.setMapMode(name)
      }}
    />)
  }

  const MapTool = ({name, label}) => {
    return (<Menu.Item
      name={name}
      active={mapTool.mapTool === name}
      content={(<Icon name={label}/>)}
      onClick={() => mapTool.setMapTool(name)}
    />)
  }

  return <div>
    <Menu>
      <MapTool name="select" label="mouse pointer"/>
      <MapTool name="add" label="plus"/>
      <MapTool name="delete" label="delete"/>
      <MapTool name="editPoints" label="edit"/>
      <MapTool name="claim" label="chain"/>
      <MapTool name="placeMarker" label="marker"/>
    </Menu>
    <Menu>
      <MapMode name="continents" label="Continents"/>
      <MapMode name="subcontinents" label="Subcontinents"/>
      <MapMode name="regions" label="Regions"/>
      <MapMode name="areas" label="Areas"/>
      <MapMode name="provinces" label="Provinces"/>
      <MapMode name="hexes" label="Hexes"/>
    </Menu>
    <Menu>
      <MapMode name="states" label="States"/>
      <MapMode name="independent_states" label="Independent"/>
      <MapMode name="settlements" label="Settlements"/>
      <MapMode name="cultures" label="Culture"/>
      <MapMode name="biomes" label="Biome"/>
    </Menu>
  </div>
};

