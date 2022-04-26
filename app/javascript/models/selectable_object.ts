import { Hex } from './hex'
import { Province } from './province'
import { Area } from './area'
import { Region } from './region'
import { Subcontinent } from './subcontinent'
import { Continent } from './continent'
import { State } from './state'
import { Settlement } from './settlement'
import { Culture } from './culture'
import { Biome } from './biome'

export const SelectableObjectTypes = {
  Hex, Province, Area, Region, Subcontinent, Continent, State, Settlement, Culture, Biome
}

export const SelectableObjectTypesByMode = {
  hexes: Hex,
  provinces: Province,
  areas: Area,
  regions: Region,
  subcontinents: Subcontinent,
  continents: Continent,
  states: State,
  independent_states: State,
  settlements: Settlement,
  cultures: Culture,
  biomes: Biome
}
