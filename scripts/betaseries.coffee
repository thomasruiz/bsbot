BetaSeries = require '../support/betaseries.coffee'

module.exports = (robot) ->
  betaSeries = new BetaSeries(robot.http)

  robot.hear /\.show (.+)/, (msg) ->
    title = msg.match[1]
    betaSeries.search_show title, (show) ->
      if show?
        last_season = show.seasons_details[show.seasons - 1]
        last_ep = "#{last_season.number}x#{last_season.episodes}"
        msg.reply "#{show.title} - Status: #{show.status} (dernier ep: #{last_ep}) - #{show.resource_url}"
      else
        msg.reply "Je ne trouve aucune série correspondant à #{title}."
