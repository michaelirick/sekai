export const SelectParent = (obj) => {
  obj.parent_id = id
  obj.parent_type = 'GeoLayer'
  console.log('selectParent', obj)
  return obj.save()
}
