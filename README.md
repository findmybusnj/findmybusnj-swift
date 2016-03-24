# FIND MY BUS NJ 2[![Build Status](https://www.bitrise.io/app/5c8adfc7a3ee8755.svg?token=LiaTatcc2s4PIYhhSC-G6A&branch=master)](https://www.bitrise.io/app/5c8adfc7a3ee8755)
An app for tracking NJ Transit bus times.

## Version: 2.0
TODO:
- Migrate old version to a totally rewritten app in Swift
- User should be able to look up stop given a bus if they don't know it
- ~~Use cards that show bus and expected arrival~~ - ✓
    * ~~tapping on them should callout to the Maps and show the transit mode that shows the user the way the bus will take, and how long it may take to get there.~~ 
- ~~Use Google's map API to return all bus stops and overlay them ontop of mapkit based on User's location~~ ✓
- ~~User should be able to get navigation to a stop via the maps application~~ ✓
- ~~Put TableView updates on main thread using `dispatch_async`~~ ✓
- ~~Look into releasing/using `unowned` on self when in a closure~~ ✓

Future Updates:
- Add Today View Widget
- Add watch app (native)

## Documentation
To generate documentation, simply use [Jazzy](https://github.com/realm/jazzy)

`sudo gem install jazzy`

Then run `jazzy` in the base folder. Documentation will be put out to the `docs` folder.


## Credits

* Thanks to [Icons8](https://icons8.com) for providing free icons.