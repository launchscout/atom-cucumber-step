StepJumper = require './step-jumper'
config = require './config'
{CompositeDisposable} = require 'atom'

module.exports =
  config: config
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'cucumber-step:jump-to-step': => @jump()

  jump: ->
    currentLine = atom.workspace.getActiveTextEditor().getLastCursor().getCurrentBufferLine()
    stepJumper = new StepJumper(currentLine)
    return unless stepJumper.firstWord
    options =
      paths: atom.config.get('cucumber-step.searchPaths')
    atom.workspace.scan stepJumper.stepTypeRegex(), options, (match) ->
      if foundMatch = stepJumper.checkMatch(match)
        [file, line] = foundMatch
        console.log("Found match at #{file}:#{line}")
        atom.workspace.open(file).done (editor) -> editor.setCursorBufferPosition([line, 0])

  deactivate: ->
    @subscriptions.dispose()
