whitelist   = require '../support/whitelist'
TriggerRepo = require '../support/trigger_repository'

module.exports = (robot) ->
  triggerRepo = new TriggerRepo(robot.brain)

  robot.respond /list triggers/, (msg) ->
    triggers = triggerRepo.all()
    formatter = (list) -> list.map((t) -> t.name).join(', ') || 'None'
    message = "Available triggers: "

    msg.reply message + formatter(triggers)

  robot.respond /learn trigger (\![a-zA-Z-_\&\^\!\#]+) (.*)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    [name, phrase] = msg.match[1..2]

    triggerRepo.save(name, phrase, msg.message.user.username)
    msg.reply "Got it.  Learned '#{name}' as '#{phrase}'."

  robot.respond /forget trigger (\![a-zA-Z-_\&\^\!\#]+)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    name = msg.match[1]

    triggerRepo.remove name
    msg.reply "Now I know nothing about '#{name}' unless it's hardcoded"

  robot.hear /^(([^:\s!]+)[:\s]+)?(!\w+)(.*)/i, (msg) ->
    user    = msg.match[2]
    name    = msg.match[3]
    args    = msg.match[4]
    phrase  = triggerRepo.find(name)?.phrase

    if phrase?
      if user?
        msg.send "#{user}: #{phrase}"
      else
        msg.send phrase
    else
      msg.reply "....ya I got nothing for #{name}."
