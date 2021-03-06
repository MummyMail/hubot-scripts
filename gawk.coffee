# Description:
#   Show me Gawker Feeds
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot gawk <feed> <N> - show N posts from the specified gawker site feed (default is all from gawker): gawk|gawker|vwag|valleywag|defamer|news|newsfeed|morningafter|morning|internet|tktk|review|books|truestories|true|domesticity|dom|antiviral|giz|gizmodo|jez|jezebel|lifehacker|lh|lhuk|lifehackeruk|kotaku
#
# Author:
#   joebillings (based on hackernews.coffee by skimbrel)

NodePie = require("nodepie")

common = "gawker.com/rss"
unique = {
  "gawk": "",
  "gawker": "",
  "vwag": "valleywag.",
  "valleywag": "valleywag.",
  "defamer": "defamer.",
  "news": "newsfeed.",
  "newsfeed": "newsfeed.",
  "morningafter": "morningafter.",
  "morning": "morningafter.",
  "internet": "internet.",
  "tktk": "tktk.",
  "review": "review.",
  "books": "books.",
  "truestories": "truestories.",
  "true": "truestories.",
  "domesticity": "domesticity.",
  "dom": "domesticity.",
  "antiviral": "anitviral.",
  "giz": "gizmodo.",
  "gizmodo": "gizmodo.",
  "jez": "jezebel.com/rss#",
  "jezebel": "jezebel.com/rss#",
  "lifehacker": "feeds.gawker.com/lifehacker/vip#",
  "lh": "feeds.gawker.com/lifehacker/full#",
  "lhuk": "feeds.feedburner.com/LifehackerUK-UKPostsOnly#",
  "lifehackeruk": "feeds.feedburner.com/LifehackerUK-UKPostsOnly#",
  "kotaku": "kotaku.",
  "kot": "kotaku."
}

module.exports = (robot) ->
  robot.respond /gawk\s?(\w*)\s?(\d*)/i, (msg) ->
    count = 19
    if !isNaN(msg.match[1])
      feedUrl = "http://" + unique["gawk"] + common
      count = msg.match[1]
    else
      feedUrl = "http://" + unique[(msg.match[1] || "gawk")] + common
      count = msg.match[2] || count
    msg.http(feedUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Couldn’t load feed " + feedUrl
      else
        feed = new NodePie(body)
        try
          feed.init()
          items = feed.getItems(0, count)
          callback = (items, i) ->
            c = i + 1;
            if !items[c]
              return
            item = items[c]
            msg.send item.getTitle() + ': ' + item.getPermalink()
            setTimeout ( ->
              callback items, c
            ), 250
            return
          item = undefined
          if items.length
            item = items[0]
            msg.send item.getTitle() + ': ' + item.getPermalink()
            setTimeout (->
              callback items, 0
              return
            ), 250
        catch e
          console.log(e)
          msg.send "Pah: " + feedUrl
