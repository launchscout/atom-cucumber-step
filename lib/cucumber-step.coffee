
StepJumper = require './step-jumper'
pkg = require '../package.json'
{CompositeDisposable} = require 'atom'

module.exports =

  subscriptions: null

  config:
    step_path:
      title: 'step-definitions-path'
      description: 'define your step defenitions path relative to the features folder'
      type :'array'
      default: ["**/features/step_definitions/**/*.rb",
-              "**/features/step_definitions/**/*.js"]

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'cucumber-step:jump-to-step': => @jump()

  jump: ->
    currentLine = atom.workspace.getActiveTextEditor().getLastCursor().getCurrentBufferLine()
    stepJumper = new StepJumper(currentLine)
    return unless stepJumper.firstWord
    options =
      paths:   atom.config.get(pkg.name + '.step_path')
    atom.workspace.scan stepJumper.stepTypeRegex(), options, (match) ->
      if foundMatch = stepJumper.checkMatch(match)
        [file, line] = foundMatch
        console.log("Found match at #{file}:#{line}")
        atom.workspace.open(file).done (editor) -> editor.setCursorBufferPosition([line, 0])

  deactivate: ->
    @subscriptions.dispose()
