StepJumper = require './step-jumper'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'cucumber-step:jump-to-step': => @jump()

  jump: ->
    currentEditor = atom.workspace.getActiveTextEditor()
    currentLine = currentEditor.getLastCursor().getCurrentBufferLine()
    isOutline = currentLine.match(/<[\w.-]+>/)
    currentRow = currentEditor.getLastCursor().getBufferRow()
    bufferedLines = currentEditor.getBuffer().getLines()
    while isOutline
      currentRow += 1
      nextLineText = bufferedLines[currentRow]
      if nextLineText.match(/examples:/i)
        exampleHeadText = bufferedLines[currentRow + 1].split "|"
        exampleValueText = bufferedLines[currentRow + 2].split "|"
        Column = 0
        for key in exampleHeadText
          key = key.replace /^\s+|\s+$/g, ""
          value = exampleValueText[Column].replace /^\s+|\s+$/g, ""
          if not key
            Column += 1
            continue
          #console.log("key: #{key} - #{value}")
          regex = new RegExp("<#{key}>", "g");
          currentLine = currentLine.replace regex, value
          Column += 1
        console.log("After replace outlines: #{currentLine}")
        break

    stepJumper = new StepJumper(currentLine)
    return unless stepJumper.firstWord
    options =
      paths: ["**/features/step_definitions/**/*.rb",
              "**/features/step_definitions/**/*.js",
              "**/step_definitions/**/*.rb",
              "**/step_definitions/**/*.js"
             ]
    atom.workspace.scan stepJumper.stepTypeRegex(), options, (match) ->
      if foundMatch = stepJumper.checkMatch(match)
        [file, line] = foundMatch
        console.log("Found match at #{file}:#{line}")
        atom.workspace.open(file).done (editor) -> editor.setCursorBufferPosition([line, 0])

  deactivate: ->
    @subscriptions.dispose()
