module.exports =
  class StepJumper

    constructor: (@line) ->
      matchData = @line.match(/^\s*(\w+)\s+(.*)/)
      if matchData
        @firstWord = matchData[1]
        @restOfLine = matchData[2]

    stepTypeRegex: ->
      new RegExp "(Given|When|Then)\(.*\)"

    checkMatch: ({filePath, matches}) ->
      for match in matches
        console.log("Searching in #{filePath}")
        regex = match.matchText.match(/^\w+\(\/(.*)\/\)/)[1]
        if @restOfLine.match(new RegExp(regex))
          return [filePath, match.range[0][0]]
