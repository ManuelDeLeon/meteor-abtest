Meteor.startup ->
  Template.abtestDashboard.created = ->
    Meteor.subscribe "ABTests"

  Template.abtestDashboard.helpers
    tests: -> ABTests.find()
    decFormat: (num) -> num.toFixed(2)
    intFormat: (num) -> num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    vsControlClass: ->
      if this.isControl
        "hidden"
      else if this.vsControl > 0
        "text-success"
      else if this.vsControl < 0
        "text-error"
      else
        "muted"
    significantClass: ->
      if this.isSignificant()
        "text-success"
      else
        "muted"

    alternatives: ->
      alts = []
      control = null
      for alternative of this.values
        started = this.values[alternative].started
        finished = this.values[alternative].finished
        finishedRate = if started then finished * 100 / started else 0
        item =
          isControl: not control
          isSignificant: ->
            return false if not this.control
            n = this.finished + this.control.finished
            d = Math.abs this.finished - this.control.finished
            Math.pow(d, 2) >  n
          name: alternative
          started: started
          finished: finished
          nonfinished: started - finished
          finishedRate: finishedRate
          vsControl: if control?.finishedRate then (finishedRate - control.finishedRate) * 100 / control.finishedRate  else 0
          control: control
        alts.push item
        control = item if not control

      alts
    significant: ->
      return "" if this.isControl
      if this.isSignificant() then "True" else "False"

    totals: ->
      started = 0
      finished = 0
      for alternative of this.values
        started += this.values[alternative].started
        finished += this.values[alternative].finished
      return {
        started: started
        finished: finished
        nonfinished: started - finished
        finishedRate: if started then finished * 100 / started else 0
      }
