class BetaSeries
  constructor: (@client) ->
    @key = process.env.HUBOT_BETASERIES_KEY

  search_show: (title) ->
    @get "shows/search?title=#{title}&nbpp=1", (shows) ->
      shows[0]?.title

  get: (url, callback) ->
    @client(url + "&key=#{@key}").get() (err, response, body) ->
      result = JSON.parse(body)
      return result.errors[0].text if result.errors.length > 0
      callback result


module.exports = BetaSeries
