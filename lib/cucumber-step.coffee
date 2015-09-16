StepJumper = require './step-jumper'
{CompositeDisposable} = require 'atom'

module.exports =
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
      paths: ["**/features/step_definitions/**/*.rb",
              "**/features/step_definitions/**/*.js"]
    atom.workspace.scan stepJumper.stepTypeRegex(), options, (match) ->
      if foundMatch = stepJumper.checkMatch(match)
        [file, line] = foundMatch
        console.log("Found match at #{file}:#{line}")
        atom.workspace.open(file).done (editor) -> editor.setCursorBufferPosition([line, 0])

  deactivate: ->
    @subscriptions.dispose()
