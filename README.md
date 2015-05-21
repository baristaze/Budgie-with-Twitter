# Budgie-with-Twitter
## Twitter Client
This is a Twitter client for iOS to read and compose tweets using the [Twitter API](https://apps.twitter.com/).

Time spent: `21 hours`

### Features

#### Required

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweets with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [X] User can pull to refresh
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

#### Additional
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

![Video Walkthrough]()
![Video Walkthrough]()
Credits
---------
* [Twitter API](https://apps.twitter.com/)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
* [Gifs Created with Licecap](http://www.cockos.com/licecap/)
