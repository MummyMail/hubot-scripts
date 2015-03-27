# Description:
#   Show me top iTunes stuff
#
# Dependencies:
#   "nodepie": "0.5.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot itop <N> <type> - show top N songs|albums|newreleases|musicvids|audiobooks|books|apps|freeapps|movies|rentals|tv
#
# Author:
#   joebillings

NodePie = require("nodepie")

common = "https://itunes.apple.com/"
unique = {
  "songs": "gb/rss/topsongs/limit=__N__/xml",
  "albums": "gb/rss/topalbums/limit=__N__/xml",
  "newreleases": "WebObjects/MZStore.woa/wpa/MRSS/newreleases/sf=143441/limit=__N__/rss.xml",
  "musicvideos": "gb/rss/topmusicvideos/limit=__N__/xml",
  "musicvids": "gb/rss/topmusicvideos/limit=__N__/xml",
  "vids": "gb/rss/topmusicvideos/limit=__N__/xml",
  "musicvidz": "gb/rss/topmusicvideos/limit=__N__/xml",
  "vidz": "gb/rss/topmusicvideos/limit=__N__/xml",
  "audiobooks": "gb/rss/topaudiobooks/limit=__N__/xml",
  "books": "gb/rss/toppaidebooks/limit=__N__/xml",
  "apps": "gb/rss/topgrossingapplications/limit=__N__/xml",
  "newapps": "gb/rss/newpaidapplications/limit=__N__/xml",
  "freeapps": "gb/rss/topfreeapplications/limit=__N__/xml",
  "newfreeapps": "gb/rss/newfreeapplications/limit=__N__/xml",
  "movies": "gb/rss/topmovies/limit=__N__/xml",
  "films": "gb/rss/topmovies/limit=__N__/xml",
  "rentals": "gb/rss/topvideorentals/limit=__N__/xml",
  "tv": "gb/rss/toptvseasons/limit=__N__/xml"
}

module.exports = (robot) ->
  robot.respond /itop\s?(\d*)\s?(\w*)/i, (msg) ->
    feedUrl = (common + unique[(msg.match[2] || "songs")]).replace(/__N__/, (msg.match[1] || 5))
    msg.http(feedUrl).get() (err, res, body) ->
      if res.statusCode is not 200
        msg.send "Couldn’t load feed " + feedUrl
      else
        feed = new NodePie(body)
        try
          feed.init()
          items = feed.getItems(0, 19)
          msg.send item.getTitle() + ": " + item.getPermalink() + "&at=1010l8X" for item in items
        catch e
          console.log(e)
          msg.send "Pah: " + feedUrl
