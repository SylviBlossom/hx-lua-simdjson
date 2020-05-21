# lua-simdjson
A basic lua binding to [simdjson](https://simdjson.org). The simdjson library is an incredibly fast JSON parser that uses SIMD instructions and fancy algorithms to parse JSON very quickly. It's been tested with LuaJIT 2.0/2.1 and Lua 5.1, 5.2, and 5.3 on linux

Current simdjson version: 0.3.1

## Requirements
 * lua-simdjson only works on 64bit systems.
 * a modern lua build environment with g++ and support for C++11

## Parsing
There are two main ways to parse JSON in lua-simdjson:
 1. With `parse`: this parses JSON and returns a lua table with the parsed values
 2. With `open`: this reads in the JSON and keeps it in simdjson's internal format. It can then be accessed using a JSON pointer (examples below)

Both of these methods also have support to read files on disc with `parseFile` and `openFile` respectively. If handling JSON from disk, these methods should be used and are incredibly fast.

## Typing
 * lua-simdjson uses `simdjson.null` to represent `null` values from parsed JSON.
   * Any application should use that for comparison as needed.
 * it uses `lua_pushnumber` and `lua_pushinteger` for JSON floats and ints respectively, so your lua version may handle that slightly differently.
 * All other types map as expected.

### Parse some JSON
The `parse` methods will return a normal lua table that can be interacted with.
```lua
local simdjson = require("simdjson")
local response = simdjson.parse([[
{ 
    "Image": {
        "Width":  800,
        "Height": 600,
        "Title":  "View from 15th Floor",
        "Thumbnail": {
            "Url":    "http://www.example.com/image/481989943",
            "Height": 125,
            "Width":  100
        },
        "Animated" : false,
        "IDs": [116, 943, 234, 38793]
    }
}
]])
print(response["Images"]["Width"])

-- OR to parse a file from disk
local fileResponse = simdjson.parseFile("jsonexamples/twitter.json")
print(fileResponse["statuses"][1]["id"])

```

### Open some json
The `open` methods currently require the use of a JSON pointer, but are very quick.
```lua
local simdjson = require("simdjson")
local response = simdjson.parse([[
{ 
    "Image": {
        "Width":  800,
        "Height": 600,
        "Title":  "View from 15th Floor",
        "Thumbnail": {
            "Url":    "http://www.example.com/image/481989943",
            "Height": 125,
            "Width":  100
        },
        "Animated" : false,
        "IDs": [116, 943, 234, 38793]
    }
}
]])
print(response.at("Images/Width"))

-- OR to parse a file from disk
local fileResponse = simdjson.parseFile("jsonexamples/twitter.json")
print(fileResponse.at("statuses/0/id") --using a JSON pointer

```
The `open` and `parse` codeblocks should print out the same values. It's worth noting that the JSON pointer indexes from 0.

This lazy style of using the simdjson data structure could also be used with array access in the future, and would result in ultra-fast JSON parsing.

## Benchmarks
TODO: add some benchmarks

## Caveats
 * there is no encoding/dumping a lua table to JSON (yet!)
 * it only works on 64 bit systems (possibly only Linux, more testing is needed)
 * it builds a large binary. On a modern linux system, it ended up being \~200k (lua-cjson comes in at 42k)
 * since it's an external module, it's not quite as easy to just grab the file and go.
 * it needs a compiler that supports at least C++11

## Error Handling
lua-simdjson will error out with any errors from simdjson encountered while parsing. They are fairly informative as to what has gone wrong during parsing.

## Licenses
 * The jsonexamples, src/simdjson.cpp, src/simdjson.h are unmodified from the released version simdjson under the Apache License 2.0.
 * All other files/folders are apart of lua-cjson also under the Apache License 2.0.