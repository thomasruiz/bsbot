class BetaSeries
  constructor: (@client, @brain) ->
    @baseUrl = "https://api.betaseries.com/"
    @key = process.env.HUBOT_BETASERIES_KEY

  authorize: (callback) ->
    @post "members/oauth", (body) ->
      callback body.oauth.key

  saveToken: (user, token, callback) ->
    @brain.set user, token
    callback()

  searchShow: (title, callback) ->
    @get "shows/search?title=#{title}&nbpp=1", (body) ->
      callback body.shows[0]

  searchMovie: (title, callback) ->
    @get "movies/search?title=#{title}&nbpp=1", (body) ->
      callback body.movies[0]

  get: (url, callback) ->
    @client(@buildUrl url).get() @handleResponse(callback)

  post: (url, callback) ->
    @client(@buildUrl url).post() @handleResponse(callback)

  buildUrl: (url) ->
    sign = if (url.indexOf('?') == -1) then '?' else '&'
    key = "#{sign}key=#{@key}"
    a = @baseUrl + url + key
    console.log a
    a

  handleResponse: (callback) ->
    (err, response, body) ->
      result = JSON.parse(body)
      return result.errors[0].text if result.errors.length > 0
      callback result


module.exports = BetaSeries
