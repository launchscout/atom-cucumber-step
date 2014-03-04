{View} = require 'atom'

module.exports =
class CucumberStepView extends View
  @content: ->
    @div class: 'cucumber-step overlay from-top', =>
      @div "The CucumberStep package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "cucumber-step:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "CucumberStepView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
