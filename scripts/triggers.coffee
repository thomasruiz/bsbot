defaultCommands = ['.show', '.serie', '.film', '.movie']

whitelist   = require '../support/whitelist'
TriggerRepo = require '../support/trigger_repository'

module.exports = (robot) ->
  triggerRepo = new TriggerRepo(robot.brain)

  robot.respond /list commands/, (msg) ->
    triggers = triggerRepo.all()
    triggers.push { name: trigger } for trigger in defaultCommands
    formatter = (list) -> list.map((t) -> t.name).join(', ') || 'Aucune'
    message = "Commandes disponibles : "

    msg.reply message + formatter(triggers)

  robot.respond /learn command (\.[a-zA-Z-_\&\^\!\#]+) (.*)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    [name, phrase] = msg.match[1..2]

    triggerRepo.save(name, phrase, msg.message.user.username)
    msg.reply "Commande #{name} apprise."

  robot.respond /forget command (\.[a-zA-Z-_\&\^\!\#]+)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    name = msg.match[1]

    triggerRepo.remove name
    msg.reply "Commande #{name} oubliée!"

  robot.hear /^(([^:\s!]+)[:\s]+)?(\.\w+)(.*)/i, (msg) ->
    user    = msg.match[2]
    name    = msg.match[3]

    return if name in defaultCommands

    phrase  = triggerRepo.find(name)?.phrase

    if phrase?
      if user?
        msg.send "#{user}: #{phrase}"
      else
        msg.send phrase
    else
      msg.reply "Commande #{name} inconnue."
