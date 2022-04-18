import * as React from 'react'

export const MapSelectionContext = React.createContext({
  selectedObject: null,
  setSelectedObject: (_) => {}
})
