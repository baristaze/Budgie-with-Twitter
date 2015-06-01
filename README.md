# Budgie-with-Twitter
## Twitter Client
This is a Twitter client for iOS to read and compose tweets using the [Twitter API](https://apps.twitter.com/).

Time spent: `25 hours` (Week-2) `21 hours` (Week-1) 

### Features

#### Required
(WEEK 2)
- [X] [Hamburguer Menu] Dragging anywhere in any view reveals the menu.
- [X] [Hamburguer Menu] The menu includes links to your profile, the home timeline, the mentions, Search, Switch Accounts, Settings (not available yet) views and LogOut.
- [X] [Hamburguer Menu] The menu looks similar to the LinkedIn menu.
- [X] [Profile Page] Contains the user header view
- [X] [Profile Page] Contains a section with the users basic stats: # following, # followers
- [X] Tapping on a user image brings up that user's profile page

(WEEK 1)
- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweets with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [X] User can pull to refresh
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional
(WEEK 2)
- [X] [Profile Page] Implements the paging view for the user description. (scroll horizontally)
- [X] [Profile Page] As the paging view moves, the opacity of the content of the scroll view decreases. (I couldn't find the  mentioned effect on the actual twitter app so I did this one instead)
- [X] [Profile Page] Pulling down the profile page should blur and resize the header image.
- [X] Account switching
	- [X] Long press on tab bar to bring up Account view with animation
	- [X] Tap account to switch to
	- [X] Include a plus button to Add an Account
	- [X] Swipe to delete an account 

(WEEK 1)
- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

#### Additional
(WEEK 2)
- [X] [Profile Page] The lower part of the Profile Page is a Collection View that can display "Last User Tweets", "Media Gallery" and "Friends List".
	- [X] Switch from one section to another using a segmented control
	- [X] Each Section has a different LayOut
	- [X] Each Section has a custom made Collection View Cell
	- [X] Taping in a User from the friends list will reload the profile page with that user info
- [X] [Hamburger Menu] Added Bouncing effect when "opening/closing" the menu
- [X] Tab Bar include links to: Home Timeline, Mentions, Search And Profile
- [X] Added Mentions page similar to the Home Timeline
- [X] [Search] Added Search Page
	- [X] User can search both Tweets and Users (using a segmentedControl)
- [X] [Twitter API] Added methods to: searchTweets, searchUsers, parseSearchQuery, requestFriendList, requestMentionTimeline, requestUserTimeline and requestUserMedia.
- [X] Created custom.plist to store global constants (i.e. secret keys, consumer key, base url, url paths…)
- [X] App saves last tweets requested (using NSUserDefaults) as timeline "placeHolders" in case the next time the App runs there is no conectivity
- [X] Added activity indicators  (usign MRProgress Library) where Data Load is required
- [X] Includes custom Launch Screen & App Icons for each device size
- [X] Launch Screen includes animation. Budgie mascot scale up and eventually dissapear before displaying the HomeTimeLine

(WEEK 1)
- [X] Implemented simple pseudo-cache on Twitter Client to reduce number of calls to API
	- Internal methods of BudgieApp always request 20 tweets at a time
	- Budgie’s Internal Client always request 200 tweets from Twitter API (max. allowed)
	- The Twitter API is only called if:
		- It’s the first call since the App Started
		- The User request’s tweets not present in the cache
		- After a pull-to-refresh is performed (refresh will flush the cache)
- [X] Instead of showing the createdAt date, tweet displays the interval since its creation in the same way that twitter does (seconds, minutes, or hours. Complete date for tweets older that 1 day)
- [X] Added Profile Page displaying current user info (including banner image) and let's the user LogOut from the App.

### Walkthrough
**GIF 1/3:** Hamburger Menu, HomeTimeLine view, Mentions view, Search view & LogOut/LogIng

![Video Walkthrough](http://i.imgur.com/1Tt6QUd.gif)


**GIF 2/3:** User Profile

![Video Walkthrough](http://i.imgur.com/wbTVnbU.gif)


**GIF 3/3:** Account Switching, Add Account, LongPress on Tab Bar & Click User Image to access Profile

![Video Walkthrough](http://i.imgur.com/Ingx1AK.gif)

Credits
---------
* [Twitter API](https://apps.twitter.com/)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
* [GIFs Created with Licecap](http://www.cockos.com/licecap/)
