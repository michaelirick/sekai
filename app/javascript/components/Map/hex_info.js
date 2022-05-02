// import html from 'utils/html'
// import truth from 'utils/truth'
// import coalesce from 'utils/coalesce'
import api from 'utils/api'
// eslint-disable-next-line no-use-before-define
import * as React from 'react'

const HexInfo = (props) => {
  console.log('HexInfo', props)
  const hex = props.hex.h ?? {}
  const header = () => {
    return (
      <h3>{hex.title}</h3>
    )
  }

  const coords = () => {
    return <p>{`(${hex.x}, ${hex.y})`}</p>
  }

  const formatPointsForApi = (points) => {
    return points.map((p, i) => p.reverse()).reverse();
  }

  const updateBoundaries = () => {
    console.log('points', props.points);
    api.post(`/admin/hexes/${hex.id}/update_boundaries.json`, {
      points: formatPointsForApi(props.points)
    })
      .then((response) => console.log('updateBoundaries', response))
  }

  const edit = () => {
    return (
      <a
        href={`/admin/hexes/${hex.id}/edit?hex[boundaries]=${props.points}`}
        target="_blank"
        class="button"
        >Edit</a>
    )
  }

  // const province = () => {
  //   return html.p('province', {}, `Province: ${hex.province_id}`)
  // }

  const updateBoundariesButton = () => {
    return (
      <a
        onClick={(e) => updateBoundaries()}
        class='button'
        >Update Boundaries</a>
    )
    // return html.a('updateBoundaries', {
    //   onClick: (e) => updateBoundaries(),
    //   className: 'button'
    // }, 'Update Boundaries')
  }


  const create = () => {
    return (
      <a
        href={`/admin/hexes/new?hex[world_id]=${hex.world_id}&hex[x]=${hex.x}&hex[y]=${hex.y}&hex[boundaries]=${formatPointsForApi(props.points)}`}
        target="_blank"
        >New</a>
    );
  }
  // const create = () => {
  //   return html.a('create', {
  //     href: `/admin/hexes/new?hex[world_id]=${hex.world_id}&hex[x]=${hex.x}&hex[y]=${hex.y}&hex[boundaries]=${props.points}`,
  //     target: '_blank'
  //   }, 'New')
  // }

  const content = () => {
    if (!truth.isTruthy(hex.id)) { return create() }

    return [
      header(),
      coords(),
      // province(),
      edit(),
      updateBoundariesButton()
    ]
  }

  return (
    <div>
      {content()}
    </div>
  )

  // return html.div('info', {}, content())
}

export default HexInfo
