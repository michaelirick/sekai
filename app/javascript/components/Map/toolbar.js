import * as React from "react";
import { Icon, Menu } from 'semantic-ui-react'
import { MapToolContext } from './map_context'
import { useContext } from 'react'

export const ToolBar = (props) => {
  const {mapTool, setMapTool} = useContext(MapToolContext);
  console.log('ToolBar', props)
  const MapMode = ({name, label}) => {
    return (<Menu.Item
      name={name}
      active={props.mapMode === name}
      content={label}
      onClick={() => props.setMapMode(name)}
    />)
  }

  const MapTool = ({name, label}) => {
    return (<Menu.Item
      name={name}
      active={mapTool === name}
      content={(<Icon name={label}/>)}
      onClick={() => setMapTool(name)}
    />)
  }

  return <div>
    <Menu>
      <MapTool name="select" label="mouse pointer"/>
      <MapTool name="add" label="plus"/>
    </Menu>
    <Menu>
      <MapMode name="continents" label="Continents"/>
      <MapMode name="hexes" label="Hexes"/>
    </Menu>
  </div>
};

