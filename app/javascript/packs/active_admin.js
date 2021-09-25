// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import '../stylesheets/active_admin'

import '@activeadmin/activeadmin'
import '@fortawesome/fontawesome-free/css/all.css'
import 'arctic_admin'
// Support component names relative to this directory:
const componentRequireContext = require.context('components', true)
const ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)
