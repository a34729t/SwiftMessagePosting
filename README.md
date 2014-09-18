### TODO

Comments:
* Refactor MPPost and MPComment (and the associated code in EditPostVC, which should be in the model objects)
* When typing a comment, does not always immediately show in ViewPostTVC
* Rename ViewPostTVC to PostDetailTVC

Networking:
* Figure out the network queue, which we really do want to use!
* Add reachability check on post/comment creation (once network stuff works)

Future:
* Need some sort of custom UITextView with proper text alignment, size, placeholder text, etc.
* Make UI suck less in general
* Comment limit is 1000 right now... pagination?
* Fix up the post details page - comment background should be different
* What should go in the menu?
* Investigate finding/writing PFObject category that is NSCoding/CoreData compatible.


### DONE

- Post needs to update its updatedAt value and use this in fetchedresultscontroller
- Comment doesn't show up in post detail view!???
- COmments do not get added to viewpostTVC when created :(
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