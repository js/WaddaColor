# WaddaColor

Swift library for a naming a color, based on a closest match to the colors in
Ingrid Sundbergs [Color Thesaurus](http://ingridsundberg.com/2014/02/04/the-color-thesaurus/).

Just give it any color and it will attemp to give the name of the closest color that matches, and what a color it is.

## Usage

Via UIColor extention:

	UIColor.blackColor().name // Black

or via a `WaddaColor` instance:

    let wadda = WaddaColor(color: UIColor.orange())
    let match = wadda.closestMatch()
    return match.name // Tangerine
	
## Example app

The Xcode project contains a sample app target called WhatTheColor

![screenshot](WhatTheColor/Screenshot/WhatTheColor.png)

## License

MIT, see LICENSE

