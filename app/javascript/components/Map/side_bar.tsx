import * as React from "react";

import BlankHex from './sidebar/hex/blank'
import { HexShow } from './sidebar/hex/hex'
import { Continent } from './sidebar/continents/continent'
import { Button, Grid, Tab } from 'semantic-ui-react'
import { StateShow } from './sidebar/state'
import { MapToolContext } from './map_context'
import { useContext, useEffect } from 'react'
import { Find } from './sidebar/find'

type SideBarProps = {
  children?: React.ReactNode;
  selectedObject: unknown
  setSelectedObject: unknown
};

const SideBar = (props: SideBarProps) => {
  const mapTool = useContext(MapToolContext);
  console.log('SideBar', props);

  const list = () => {
    return (
      <Tab.Pane>
        <Find/>
      </Tab.Pane>
    )
  }
  const contents = () => {
    if (!props.selectedObject)
      return <div></div>

    // if (props.selectedObject.type === 'blank_hex') {
    //   return <BlankHex hex={props.selectedObject}/>;
    // }

    // if (props.selectedObject.type === 'Continent') {
    //   return <Continent id={props.selectedObject.id}/>;
    // }

    if (props.selectedObject.type === 'Hex') {
      return <HexShow {...props.selectedObject}/>;
    }

    // if (props.selectedObject.type === 'State') {
    //   return <StateShow {...props.selectedObject}/>;
    // }
    if (mapTool.mapTool === 'editPoints') {
      return (
        <div>
          <Button
            onClick={() => {
              props.selectedObject.updateGeometry(mapTool.mapToolPoints)
                .then(response => console.log('saved'))
                .catch(error => console.log('error', error))
            }}
          >
            Update Geometry
          </Button>
          <Button
            onClick={() => mapTool.setMapToolPoints([])}
          >
            Clear Points
          </Button>
        </div>
      )
    }

    return <div></div>;
  };

  const debug = () => {
    return null;
    return (
      <div><pre>{JSON.stringify(props)}</pre></div>
    )
  }

  return (
    <div style={{maxWidth: '20%'}}>
      <Tab
        panes={[
          { menuItem: 'Select', render: () => (<Tab.Pane>{contents()}</Tab.Pane>) },
          { menuItem: 'Find', render: () => list() }
        ]}
      />
    </div>
  );
}

export default SideBar;
