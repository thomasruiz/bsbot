BetaSeries = require '../support/betaseries.coffee'

module.exports = (robot) ->
  getUser = (msg) -> robot.brain.get msg.message.user.name
  betaSeries = new BetaSeries(robot.http, robot.brain)

  robot.respond /authorize me/, (msg) ->
    betaSeries.authorize (key) ->
      url = "https://www.betaseries.com/oauth?key=#{key}"
      msg.sendPrivate "Va sur l'url suivante et suis les indications: #{url}"

  robot.respond /token ([0-9a-z]+)/, (msg) ->
    user = msg.message.user.name
    robot.brain.set user, msg.match[1]
    msg.reply "Token enregistré"

  robot.respond /trouve (moi )?une série comme (.+)/, (msg) ->
    user = getUser msg
    betaSeries.searchShow user, msg.match[2], (show) ->
      betaSeries.similarShows user, show.id, (shows) ->
        similarShows = if shows? then (shows.map (show) -> show.title) else "Aucun"
        msg.reply "Séries comme #{msg.match[2]}: #{similarShows}"

  robot.hear /\.(show|serie) (.+)/, (msg) ->
    user = getUser msg
    betaSeries.searchShow user, msg.match[2], (show) ->
      if show.episodes == 0
        betaSeries.nextEpisode user, show.id, (episode) ->
          status = "#{show.status} (débute le #{episode.date})"
          msg.reply "#{show.title} - Status: #{status} - #{show.resource_url}"
      else
        betaSeries.lastEpisode user, show.id, (episode) ->
          if user?
            episodeStatus = if episode.user.seen then " à jour" else " en retard"
          else
            episodeStatus = ""
          status = "#{show.status} (#{episode.code}#{episodeStatus})"
          msg.reply "#{show.title} - Status: #{status} - #{show.resource_url}"

  robot.hear /\.(film|movie) (.+)/, (msg) ->
    user = getUser msg
    betaSeries.searchMovie user, msg.match[2], (film) ->
      film.url = "https://www.betaseries.com/film/#{film.id}-#{film.url}"
      msg.reply "#{film.title} (#{film.production_year}) by #{film.director} - #{film.url}"
