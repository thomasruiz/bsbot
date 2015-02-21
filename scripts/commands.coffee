commands =
  streaming: "BetaSeries ne permet pas de regarder les épisodes en streaming. Nous diffusons uniquement leurs plannings et permettons le téléchargement des sous-titres des épisodes. Pour plus d'informations, va sur http://www.betaseries.com/faq"

module.exports = (robot) ->
  robot.respond /list commands/, (msg) ->
    list = []
    for command, phrase of commands
      list.push command

    msg.reply "Available commands: #{list.join ', '}"

  robot.hear /^(([^:\s!]+)[:\s]+)?(!\w+)/i, (msg) ->
    user = msg.match[2]
    name = msg.match[3].substr(1)
    phrase = commands[name]

    if phrase?
      if user?
        msg.send "#{user}: #{phrase}"
      else
        msg.send phrase

