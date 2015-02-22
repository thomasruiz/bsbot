BetaSeries = require '../support/betaseries.coffee'

module.exports = (robot) ->
  betaSeries = new BetaSeries(robot.http)

  robot.hear /\.show (.+)/, (msg) ->
    show = msg.match[1]
    msg.reply betaSeries.search_show(show)
