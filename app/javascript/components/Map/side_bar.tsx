import * as React from 'react'

type SideBarProps = {
  children?: React.ReactNode;
};

const SideBar = (props: SideBarProps) => {
  return <div>{props.children}</div>
}

export default SideBar
