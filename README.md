### TODO

- We have to not create a coredata object until the server says yes, at which case it's go time'
- Add reachability check on post/comment creation
- Load post from server


- Add comment extensions class


* Make UI suck less in general
* Fix up the post details page - comment background should be different
* What should go in the menu?

### DONE

* Test reachability
* Add simple analytics to parse
-- Compose post & comment
-- Time in app
-- Launch
* Parse chosen for server-side
* Figure out reachability in swift (bridging header )
* Create basic NUX VC (with custom dismiss segue)
* Add a menu button from main screen
* Add initial hook for NUX
* Create post/comment VC should be the same one (to avoid duplicated code)
* XCode 6b6 developer certs fixed

### NOTE

Needs XCode 6b6 to work properly! The latest beta fixes broken UITableview stuff/transitions/cells/everything!