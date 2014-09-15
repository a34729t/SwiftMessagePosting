### TODO



- Post needs to update its updatedAt value and use this in fetchedresultscontroller
- COmments do not get added to viewpostTVC when created :(


- Post cursoring (maybe use the newest post/comment ID + Date as the cursor for get new posts from here?)
- Add reachability check on post/comment creation
- Comment limit is 1000 right now... pagination?

* Make UI suck less in general
* Fix up the post details page - comment background should be different
* What should go in the menu?

### DONE

- Add PTR to comment view? Meh
- Load comments in post tableview
- Add comment creation + add to server
-- Basically, when we get PFPost, we will also get the PFComments relating to it -> All these are saved in Core Data
-- When we write a comment, we first need to ask Parse for the PFObject, and then save the comment to it
- Add pull to refresh to main table view?
- Figure out core data dedup on load from server
- We have to not create a coredata object until the server says yes, at which case it's go time'
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