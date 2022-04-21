import * as React from 'react'

export const MapSelectionContext = React.createContext({
  selectedObject: null,
  setSelectedObject: (_) => {}
})

export const MapToolContext = React.createContext({
  mapTool: null,
  setMapTool: (_) => {}
})
