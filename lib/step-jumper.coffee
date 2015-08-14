module.exports =
  class StepJumper

    constructor: (@line) ->
      matchData = @line.match(/^\s*(\w+)\s+(.*)/)
      if matchData
        @firstWord = matchData[1]
        @restOfLine = matchData[2]

    stepTypeRegex: ->
      new RegExp "(Given|When|Then|And)\(.*\)"

    checkMatch: ({filePath, matches}) ->
      for match in matches
        console.log("Searching in #{filePath}")
        regex = match.matchText.match(/\/([^/]*)/)
        try
          regex = new RegExp(regex[1])
        catch e
          console.log(e)
          continue
        if @restOfLine.match(regex)
          return [filePath, match.range[0][0]]
