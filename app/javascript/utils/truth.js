let truth = {};

// this is ruby style falseness
// NOTE: 0 is not falsy
truth['isFalsy'] = (value) => {
  return typeof value === 'undefined' || value === null || value === false
}

// the opposite of above
truth['isTruthy'] = (value) => {
  return !truth.isFalsy(value);
}

truth['isT'] = (value) => truth.isTruthy(value);

truth['isF'] = (value) => !truth.isTruthy(value);

export default truth;