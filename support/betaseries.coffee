class BetaSeries
  constructor: (@client, @brain) ->
    @baseUrl = "https://api.betaseries.com/"
    @key = process.env.HUBOT_BETASERIES_KEY

  authorize: (user, callback) ->
    @post "members/oauth", user, (body) ->
      callback body.oauth.key

  saveToken: (user, token) ->
    @brain.set user, token

  searchShow: (user, title, callback) ->
    @get "shows/search?title=#{title}&nbpp=1", user, (body) ->
      callback body.shows[0] if body.shows[0]?

  searchMovie: (user, title, callback) ->
    @get "movies/search?title=#{title}&nbpp=1", user, (body) ->
      callback body.movies[0] if body.movies[0]?

  similarShows: (user, id, callback) ->
    @get "shows/similars?id=#{id}", user, (body) ->
      callback body.similars if body.similars[0]?

  markAsSeen: (user, id, callback) ->
    callback false unless @brain.user?

  get: (url, user, callback) ->
    @client(@buildUrl(url, user)).get() @handleResponse(callback)

  post: (url, user, callback) ->
    @client(@buildUrl(url, user)).post() @handleResponse(callback)

  buildUrl: (url, user) ->
    sign = if (url.indexOf('?') == -1) then '?' else '&'
    key = "#{sign}key=#{@key}"
    @baseUrl + url + key + "&token=#{@brain.get user}"

  handleResponse: (callback) ->
    (err, response, body) ->
      result = JSON.parse(body)
      return result.errors[0].text if result.errors.length > 0
      callback result


module.exports = BetaSeries
