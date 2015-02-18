# Description:
#   Show me Huffington Post Feeds
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot huff <feed> <N> - show N posts from the specified huff post feed (default is all from full): full|pol|ent|style|student|lifestyle|comedy|celeb|news|tech|sport
#
# Author:
#   joebillings (based on hackernews.coffee by skimbrel)

NodePie = require("nodepie")

baseUrl = "http://www.huffingtonpost.co.uk/"
endpoint = {
  "full": "feeds/index.xml",
  "pol": "feeds/verticals/uk-politics/index.xml",
  "politics": "feeds/verticals/uk-politics/index.xml",
  "ent": "feeds/verticals/uk-entertainment/index.xml",
  "entertainment": "feeds/verticals/uk-entertainment/index.xml",
  "style": "feeds/verticals/uk-style/index.xml",
  "student": "feeds/verticals/uk-universities-education/index.xml",
  "edu": "feeds/verticals/uk-universities-education/index.xml",
  "education": "feeds/verticals/uk-universities-education/index.xml",
  "life": "feeds/verticals/uk-lifestyle/index.xml",
  "lifestyle": "feeds/verticals/uk-lifestyle/index.xml",
  "comedy": "feeds/verticals/uk-comedy/index.xml",
  "celeb": "tag/celebrity/feed/",
  "celebrity": "tag/celebrity/feed/",
  "news": "feeds/verticals/uk/index.xml",
  "tech": "feeds/verticals/uk-tech/index.xml",
  "technology": "feeds/verticals/uk-tech/index.xml",
  "sport": "feeds/verticals/uk-sport/index.xml"
}

module.exports = (robot) ->
  robot.respond /huff\s?(\w*)\s?(\d*)/i, (msg) ->
    #if(msg.match[1] && !(/^full|pol|ent|style|student|lifestyle|comedy|celeb|news|tech|sport$/.test(msg.match[1])))
    #  msg.send "Oops, there’s no feed called " + msg.match[1]
    feedUrl = baseUrl + endpoint[(msg.match[1] || "full")]
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
