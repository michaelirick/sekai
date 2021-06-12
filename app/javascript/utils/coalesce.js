import truth from 'utils/truth'

let coalesce = (...args) => {
  for(let i = 0; i < args.length; i++)
    if (truth.isTruthy(args[i]))
      return args[i];

  return null;
}

export default coalesce;
