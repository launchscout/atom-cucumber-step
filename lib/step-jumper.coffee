module.exports =
  class StepJumper

    constructor: (@line) ->
      matchData = @line.match(/^\s*(\w+)\s+(.*)/)
      if matchData
        @firstWord = matchData[1]
        @restOfLine = matchData[2]

    stepTypeRegex: ->
      new RegExp "#{@firstWord}\(.*\)" if @firstWord

    checkMatch: ({filePath, matches}) ->
      for match in matches
        regex = match.matchText.match(/^\w+\(\/(.*)\/\)/)[1]
        console.log
        if @restOfLine.match(new RegExp(regex))
          return [filePath, match.range[0][0]]
