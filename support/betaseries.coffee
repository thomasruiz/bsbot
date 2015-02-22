class BetaSeries
  constructor: (@client) ->
    @baseUrl = "https://api.betaseries.com/"
    @key = process.env.HUBOT_BETASERIES_KEY

  search_show: (title, callback) ->
    @get "shows/search?title=#{title}&nbpp=1", (body) ->
      callback body.shows[0]

  get: (url, callback) ->
    @client(@baseUrl + url + "&key=#{@key}").get() (err, response, body) ->
      result = JSON.parse(body)
      return result.errors[0].text if result.errors.length > 0
      callback result


module.exports = BetaSeries
