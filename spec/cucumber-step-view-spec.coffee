CucumberStepView = require '../lib/cucumber-step-view'
{WorkspaceView} = require 'atom'

describe "CucumberStepView", ->
  it "has one valid test", ->
    expect("life").toBe "life"
