BetaSeries = require '../support/betaseries.coffee'

module.exports = (robot) ->
  betaSeries = new BetaSeries(robot.http)

  robot.hear /\.(show|serie) (.+)/, (msg) ->
    title = msg.match[2]
    betaSeries.searchShow title, (show) ->
      if show?
        last_season = show.seasons_details[show.seasons - 1]
        last_ep = "#{last_season.number}x#{last_season.episodes}"
        msg.reply "#{show.title} - Status: #{show.status} (dernier ep: #{last_ep}) - #{show.resource_url}"
      else
        msg.reply "Je ne trouve aucune série correspondant à #{title}."

  robot.hear /\.(film|movie) (.+)/, (msg) ->
    title = msg.match[2]
    betaSeries.searchMovie title, (film) ->
      if film?
        film.url = "https://www.betaseries.com/film/#{film.id}-#{film.url}"
        msg.reply "#{film.title} (#{film.production_year}) by #{film.director} - #{film.url}"
      else
        msg.reply "Je ne trouve aucun film correspondant à #{title}."
