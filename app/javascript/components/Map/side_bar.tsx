import * as React from "react";

import BlankHex from './sidebar/hex/blank'

type SideBarProps = {
  children?: React.ReactNode;
  selectedObject: {
    blank_hex?: unknown
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

    return <div></div>;
  };

  return (
    <div class="panel">
      {title()}
      <div class="panel_contents">
        {contents()}
      </div>
    </div>
  );
}

export default SideBar;
