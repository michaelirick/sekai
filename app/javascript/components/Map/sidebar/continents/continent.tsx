import * as React from 'react'
import {useState} from 'react'
import api from 'utils/api'

export type ContinentProps = {
  id: number;
};

export const Continent = (props: ContinentProps) => {
  const [hex, setHex] = useState({id: props.id});
  const [x, setX] = useState();
  const [y, setY] = useState();

  const updateHex = () => {
    api.put(`/admin/hexes/${hex.id}/`, {
      x: x
    });
  }
  return (
    <div>
      <input value={x} onChange={(e) => setX(e.target.value)}/>
      <button onClick={(e) => updateHex()}>Update</button>
    </div>
  );
}
