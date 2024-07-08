# ObjectPool Module

## Overview
The `ObjectPool` module provides a mechanism for efficiently managing objects without causing FPS drops. It allows objects to be reused rather than recreated, optimizing performance and resource usage.

## Usage

1. **Initialization:**
   - Create an instance of `ObjectPool` using `ObjectPool.new()` with specified object template, creation, and reset functions.
   - The `create` function should create new objects based on the specified template.
   - The `reset` function should reset the object's state to be ready for reuse.

2. **Object Retrieval:**
   - Retrieve objects from the pool using `:GetObject()` method.
   - New objects are created if the pool is empty, up to the maximum pool size limit.

3. **Object Return:**
   - Return objects to the pool after use with `:ReturnObject(obj)`.
   - Objects are reset and made available for reuse.

## Example

```lua
local ObjectPool = require(script.ObjectPool)

-- Define object creation and reset functions
local function createObject(template: Model)
    local newObj = template:Clone()
    return newObj
end

local function resetObject(obj)
    obj.Position = Vector3.new(0, 0, 0)
    obj.Parent = nil
end

local objectTemplate = Instance.new("Part")
local minSize, maxSize = 10, 50
local pool = ObjectPool.new(objectTemplate, createObject, resetObject, minSize, maxSize)

-- Get an object from the pool and then return it
local obj1 = pool:GetObject()
wait(1)
pool:ReturnObject(obj1)

local obj2 = pool:GetObject()
wait(1)
pool:ReturnObject(obj2)
```

- More information, about functions you can read in module.

## Links

- [GitHub Repository](https://github.com/notqaltx/ObjectPool.git)
- [Creator's YouTube Channel](https://youtube.com/@qaltx)

-- Programmed by notqaltx (@qaltx)
