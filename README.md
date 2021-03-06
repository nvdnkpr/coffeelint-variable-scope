# coffeelint-variable-scope [![Build Status](https://secure.travis-ci.org/fragphace/coffeelint-variable-scope.png?branch=master)](http://travis-ci.org/fragphace/coffeelint-variable-scope)


[CoffeeLint](http://www.coffeelint.org/) rule that warns you about overwriting outer scope variable.

```
  ✗ ./level.coffee
     ⚡ #1-8: Outer scope variable overwrite. a.

✗ Lint! » 2 errors and 1 warning in 2 files
```

**Means**: Variable `a` assigned in `1st` line and overwriten in `8th` line of `level.coffee` file.

## Installation

```
npm install coffeelint-variable-scope
```

## Usage

Put this in your coffeelint config:

```
"variable_scope": {
    "module": "coffeelint-variable-scope",
    "scopeDiff": 1
}
```

## Options

`scopeDiff` - Reports an error if upper and lower variable 
assign scope level difference is equal/bigger than `scopeDiff`. Default: `1`.

## Test

```
npm test
```