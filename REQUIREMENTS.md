- Tested and built with MATLAB R2016a @Linux/Ubuntu14.04trusty 
- Should work with all versions which support the dot notation (`obj.attribute`)
  for objects, prior versions which only support `get(obj, attribute)` will fail

- add project folder to path: when project folder is root, run
  `path(path, genpath(cd))`
