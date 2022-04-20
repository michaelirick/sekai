import * as React from "react";

import BlankHex from './sidebar/hex/blank'
import { Hex } from './sidebar/hex/hex'
import { Continent } from './sidebar/continents/continent'

type SideBarProps = {
  children?: React.ReactNode;
  selectedObject: {
    blank_hex?: unknown;
    continent: unknown;
    hex: unknown;
  }
  setSelectedObject: unknown
};

const SideBar = (props: SideBarProps) => {
  console.log('SideBar', props);
  const title = () => {
    return <h3>{props.selectedObject ? 'selectedjunt' : 'SideBar'}</h3>
  };

  const contents = () => {
    if (!props.selectedObject)
      return <div></div>

    if (props.selectedObject.blank_hex) {
      return <BlankHex hex={props.selectedObject.blank_hex}/>;
    }

    if (props.selectedObject.continent) {
      return <Continent id={props.selectedObject.continent.id}/>;
    }

    if (props.selectedObject.hex) {
      return <Hex id={props.selectedObject.hex.id}/>;
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
    <div class="panel">
      {title()}
      <div class="panel_contents">
        {debug()}
        {contents()}
      </div>
    </div>
  );
}

export default SideBar;
