export const SelectParent = (obj, params) => {
  obj.parent_id = params.id
  if (params.type === 'State')
    obj.parent_type = 'State'
  else
    obj.parent_type = 'GeoLayer'
  console.log('selectParent', obj)
  return obj.save()
}

export const SelectParentObjectTypes = [
  'State', 'Hex', 'Province', 'Area', 'Region', 'Subcontinent', 'Continent'
]
