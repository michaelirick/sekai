import * as React from 'react'
import {useState, createContext} from 'react'

export const useMapSelection = () => {
  const [selectedObject, setSelectedObject] = useState(null)
  return { selectedObject, setSelectedObject }
}

export const MapSelectionContext = React.createContext({
  selectedObject: null,
  setSelectedObject: (_) => {}
})

export const useMapTool = () => {
  const [mapTool, setMapTool] = useState(localStorage.getItem('mapTool') || 'select')
  const [mapToolPoints, setMapToolPoints] = useState([])
  return { mapTool, setMapTool, mapToolPoints, setMapToolPoints }
}

export const MapToolContext = createContext({
  mapTool: localStorage.getItem('mapTool') || 'select',
  setMapTool: (_) => {},
  mapToolPoints: [],
  setMapToolPoints: (_) => {}
})

export const useMapMode = () => {
  const [mapMode, setMapMode] = useState(localStorage.getItem('mapMode') || 'hexes')
  return { mapMode, setMapMode }
}

export const MapModeContext = createContext({
  mapMode: localStorage.getItem('mapMode') || 'hexes',
  setMapMode: (_) => {}
})

export const useMapView = () => {
  const [mapZoom, setMapZoom] = useState(localStorage.getItem('mapZoom') || 0)
  const [mapCenterX, setMapCenterX] = useState(localStorage.getItem('mapCenterX') || 2048)
  const [mapCenterY, setMapCenterY] = useState(localStorage.getItem('mapCenterY') || 1024)
  return {
    mapZoom,
    setMapZoom,
    mapCenterX,
    setMapCenterX,
    mapCenterY,
    setMapCenterY
  }
}

export const MapViewContext = createContext({
  mapZoom: localStorage.getItem('mapZoom') || 0,
  mapCenterX: localStorage.getItem('mapCenterX') || 2048,
  mapCenterY: localStorage.getItem('mapCenterY') || 1024,
  setMapZoom: (_) => {},
  setMapCenterX: (_) => {},
  setMapCenterY: (_) => {}
})

