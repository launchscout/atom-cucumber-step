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
        if regexMatches = match.matchText.match(/^\w+[\s+\(]['"\/](.*)['"\/]i?[\s+\)]/)
          if @restOfLine.match(new RegExp(regexMatches[1]))
            return [filePath, match.range[0][0]]
