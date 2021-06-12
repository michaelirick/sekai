import html from 'utils/html'
import truth from 'utils/truth'

const HexInfo = (props) => {
  const header = () => {
    return html.h3('header', {}, `${props.hex.title}`);
  }

  const coords = () => {
    return html.p('coords', {}, `(${props.hex.x}, ${props.hex.y})`);
  }

  const province = () => {
    return html.p('province', {}, `Province: ${props.hex.province_id}`);
  }

  const edit = () => {
    return html.a('edit', {
      href: `/admin/hexes/${props.hex.id}/edit`,
      target: '_blank'
    }, 'Edit');
  }

  const create = () => {
    return html.a('create', {
      href: `/admin/hexes/new?hex[world_id]=${props.hex.world_id}&hex[x]=${props.hex.x}&hex[y]=${props.hex.y}`,
      target: '_blank'
    }, 'New')
  }

  const content = () => {
    if (!truth.isTruthy(props.hex.id))
      return create();

    return [
      header(),
      coords(),
      province(),
      edit()
    ];
  }

  return html.div('info', {}, content());
};

export default HexInfo;