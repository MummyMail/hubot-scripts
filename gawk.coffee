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
#   hubot gawk <feed> <N> - show N posts from the specified gawker site feed (default is all from full): full|pol|ent|style|student|lifestyle|comedy|celeb|news|tech|sport
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
  "lifehacker": "lifehacker.",
  "lh": "lifehacker.",
  "kotaku": "kotaku.",
  "kot": "kotaku."
}

module.exports = (robot) ->
  robot.respond /gawk\s?(\w*)\s?(\d*)/i, (msg) ->
    feedUrl = "http://" + unique[(msg.match[1] || "gawk")] + common
    msg.http(feedUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Couldn’t load feed " + feedUrl
      else
        feed = new NodePie(body)
        try
          feed.init()
          count = msg.match[2]
          if(count)
            items = feed.getItems(0, count)
          else
            items = feed.getItems()
          msg.send item.getTitle() + ": " + item.getPermalink() for item in items
        catch e
          console.log(e)
          msg.send "Pah: " + feedUrl
