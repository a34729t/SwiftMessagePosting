### TODO

* Use bubbles for content
* Investigate bottom toolbar for uinavigation controller with keyboard + goto top/bottom capability.
* Add a comment limit for a post (1000, test with 100 comments for now!)
* Add hashtags to posts

Future:
* Add a NUX/help button on menu -> link to nux flow
* What should go in the menu?
* Investigate finding/writing PFObject category that is NSCoding/CoreData compatible.

Networking:
* Figure out the network queue, which we really do want to use! Use network queue to limit number of requests per second (ie don't update posts every ptr necessarily)
* Add reachability check on post/comment creation (once network stuff works)
* Make sure to attempt content load before page loads

### DONE

- Add goto top/bottom buttons for post detail
-- programmatic autolayout constraints
-- create a carat icons
-- make the top/bottom icons only appear when > 20 comments
- Make UI for post details suck less
- No empty cells in tableview
- Xib for all tableviewcells
- Need some sort of custom UITextView with proper text alignment, size, placeholder text, etc.
- Rename ViewPostTVC to PostDetailTVC (Swift cannot do refactoring via Xcode yet)
- When typing a comment, does not always immediately show in ViewPostTVC
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
- Test reachability
- Add simple analytics to parse
-- Compose post & comment
-- Time in app
-- Launch
- Parse chosen for server-side
- Figure out reachability in swift (bridging header )
- Create basic NUX VC (with custom dismiss segue)
- Add a menu button from main screen
- Add initial hook for NUX
- Create post/comment VC should be the same one (to avoid duplicated code)
- XCode 6b6 developer certs fixed

### NOTE

1) I am using Morten Bogh's NibDesignable class to do live rendering on UIElements. Live rendering isn't instant though; often one needs to click on another file (in the same tab) to make changes render. Clicking on another tab doesn't always seem to do the trick.

2) To get UITableViewCells to link to Xibs, I do the following:

* Create a subclass of UITableViewCell, and make the prototype cell in storyboard be of this type
* Create a subclass of IBDesignable, and add a UIView to the cell of this type
* Put both of these classes in the same file for convenience's sake
* Make the file's owner of the Xib be the subclass of IBDesignable
