# OpenSCAD Box

Reproduction of [Parametrizable Rugged Box](https://www.printables.com/model/168664-parametrizable-rugged-box-openscad) built in [OpenSCAD](http://www.openscad.org/) that focuses on the size of the inside of the box rather than the size of the outside of the box.

## Usage

Include the file `openscad-box.scad`:

```openscad
include <openscad-box.scad>
```

Use the function `openBox()`. Two boxes need to be created; a top and a bottom

```openscad
// top
openBox(length=65, width=100, height=25, shell=3, fillet=4, rib=10, clearance=0.3, top=true);

// bottom
openBox(length=65, width=100, height=45, shell=3, fillet=4, rib=10, clearance=0.3, top=false);
```

Arguments:

* __length__ Inside length of the box. Best between 50-220
* __width__ Inside width of the box. Best between 50-220
* __height__ Inside height of the box. Best between 50-220
* __fill__ Inside fill height of the box. Between 0 and `height` (default: `0`)
* __shell__ The thickness of the walls (side and bottom). Between 3-9 (default: `3`)
* __fillet__ Radius of the fillets (corners). Between 4-20 (default: `4`)
* __rib__ Rib thickness (width). Between 6-20 (default: `10`)
* __clearance__ Gap clearance for joints. Between 0.1-0.4 (default: `0.3`)
* __top__ Top or bottom box (default: `false`)

## Example

### Basic Example

Simple box with default options:

```openscad
openBox(length=65, width=100, height=25, top=true);
openBox(length=65, width=100, height=45, top=false);
```

![box_example_basic](./examples/basic.png)

### Customizer

![customizer](./examples/customizer.png)

## TODO

1. Better hinge (using screws or a pin)
2. Minumum lid snap width
3. Maximum lid snap width
4. Customizable text
  * Lid, top, bottom right
  * Base, front, bottom right
  * Base, bottom, top left
  * Base, bottom, middle left
