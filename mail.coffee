# Description:
#   Show me DailyMail Feeds
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot mail <feed> <N> - show N posts from the specified DailyMail feed (default is all from Latest Stories): latest|news|tv|femail|top|you|books|showbiz|redcarpet
#
# Author:
#   joebillings

NodePie = require("nodepie")

common = "http://www.dailymail.co.uk/"
unique = {
  "latest": "articles.rss",
  "news": "news/index.rss",
  "tv": "tvshowbiz/index.rss",
  "femail": "femail/index.rss",
  "top": "home/index.rss",
  "you": "home/you/index.rss",
  "books": "home/books/index.rss",
  "showbiz": "tvshowbiz/articles.rss",
  "redcarpet": "tvshowbiz/redcarpet/index.rss"
}

module.exports = (robot) ->
  robot.respond /mail\s?(\w*)\s?(\d*)/i, (msg) ->
    count = 19
    feedUrl = common + unique["latest"]
    if msg.match[1] and !isNaN(msg.match[1])
      count = msg.match[1]
    else if msg.match[2]
      count = msg.match[2]
      feedUrl = common + unique[msg.match[1]]
    else if msg.match[1]
      feedUrl = common + unique[msg.match[1]]
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
            ), 50
            return
          item = undefined
          if items.length
            item = items[0]
            msg.send item.getTitle() + ': ' + item.getPermalink()
            setTimeout (->
              callback items, 0
              return
            ), 500
        catch e
          console.log(e)
          msg.send "Pah: " + feedUrl
