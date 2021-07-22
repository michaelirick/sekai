import html from 'utils/html'

const SideBar = (props) => {
  const content = () => {
    return 'sidebar';
  }

  return html.div('sidebar', {
    // style: {
    //   // float: 'left',
    //   width: '270px',
    //   // marginLeft: '-270px'
    // }
  }, content());
}

export default SideBar;