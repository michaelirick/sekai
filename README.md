# README

有世界 (Yūsekai, 'having-world') is a Rails/React app to help organize my worldbuilding. I am a big user of WorldAnvil (highly recommend) but have more specific needs. This application will heavily leverage what was developed in my conlang app, Lehintos.

## 有世界

All software names come from someone trying to be overly clever; 有世界 (Yūsekai) is no exception. It initially came from attempts to pun the Japanese genre of 異世界 (isekai, 'other-world') with a further pun on Yū sounding sort of like English 'you'.

## Major Concepts

The major concepts are the Map and the History.

### Map

Perhaps the most important feature is the Map. In WorldAnvil and other tools, the map is a representation of whatever idea the worldbuilder is building and the user is generally allowed to add multiple maps for the same world. In Yuusekai, the Map is the world as an abstract, yet physical, entity. At it's base, it's a collection of hexagons of about 100sqmi which are collected into larger groupings inspired by Clausewitz Engine games (smallest to largest, Hex, Province, Area, Region, Subcontinent, Continent, World). The mechanics are inspired by Pathfinder.

### History

Next is the History. WorldAnvil has a very nice concept of history with its timeline feature. I really like the concept of Timelines and Eras, combining this with a Clausewitz style historical event tracking, the state of the World at any time can be deduced in a way that can help visualize potential plot-lines and discover plot-holes. I would like this visible in the Map above as well as a Gantt-chart-esque timeline view.

## Minor Concepts

Minor concepts include languages, cultures, states, and settlements.

### Languages

Languages play a major role in how things are named. A collection of words and relationships to other languages. A lot of this functionality comes from the Lehintos application and the diachronr gem.

### Cultures

Cultures more or less tie languages to actual representations of a population in the world.

### Religions

More to come.

### Settlements

Settlements represent largely non-food producing population centers. These form the base of most States. While they can exist in only one Hex, they exert influence to their neighbors, mostly economic, though some cultural and religious as well. Further influence requires a State.

### States

States are collections of Settlements and Hexes under a single overarching authority, no matter how loose or cohesive. This represents kingdoms, tribal confederations, hordes of monsters.
