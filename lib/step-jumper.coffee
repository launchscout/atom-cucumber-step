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
        regex = @extractRegex(match.matchText)
        continue unless regex
        try
          regex = new RegExp(regex)
        catch e
          console.log(e)
          continue
        if @restOfLine.match(regex)
          return [filePath, match.range[0][0]]

    extractRegex: (matchText) ->
      regexMatch = matchText.match(/\([^/]*\/(.*)\/[^,]*,.*\)/)
      if regexMatch
        return regexMatch[1]
      patternMatch = matchText.match(/("|')(.*)\1/)
      if patternMatch
        return patternMatch[2].replace(/(\\?["'])\$\w+\1/g,"$1(.*)$1").replace(/\$\w+/, "(\\d+)")
