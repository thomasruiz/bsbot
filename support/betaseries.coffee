class BetaSeries
  constructor: (@client) ->
    @baseUrl = "https://api.betaseries.com/"
    @key = process.env.HUBOT_BETASERIES_KEY

  authorize: (callback) ->
    @post "members/oauth", null, (body) ->
      callback body.oauth.key

  searchShow: (token, title, callback) ->
    @get "shows/search?title=#{title}&nbpp=1", token, (body) ->
      callback body.shows[0] if body.shows[0]?

  searchMovie: (token, title, callback) ->
    @get "movies/search?title=#{title}&nbpp=1", token, (body) ->
      callback body.movies[0] if body.movies[0]?

  similarShows: (token, id, callback) ->
    @get "shows/similars?id=#{id}", token, (body) ->
      callback body.similars if body.similars[0]?

  nextEpisode: (token, id, callback) ->
    @get "episodes/next?id=#{id}", token, (body) ->
      callback body.episode

  lastEpisode: (token, id, callback) ->
    @get "episodes/latest?id=#{id}", token, (body) ->
      callback body.episode

  get: (url, token, callback) ->
    @client(@buildUrl(url, token)).get() @handleResponse(callback)

  post: (url, token, callback) ->
    @client(@buildUrl(url, token)).post() @handleResponse(callback)

  buildUrl: (url, token) ->
    sign = if (url.indexOf('?') == -1) then '?' else '&'
    key = "#{sign}key=#{@key}"
    @baseUrl + url + key + "&token=#{token}"

  handleResponse: (callback) ->
    (err, response, body) ->
      result = JSON.parse(body)
      return result.errors[0].text if result.errors.length > 0
      callback result


module.exports = BetaSeries

