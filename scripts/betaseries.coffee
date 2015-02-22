BetaSeries = require '../support/betaseries.coffee'

module.exports = (robot) ->
  betaSeries = new BetaSeries(robot.http)

  robot.hear /\.show (.+)/, (msg) ->
    title = msg.match[1]
    betaSeries.search_show title, (show) ->
      if show?
        msg.reply "#{show.title} - #{show.resource_url}"
      else
        msg.reply "Je ne trouve aucune série correspondant à #{title}."
