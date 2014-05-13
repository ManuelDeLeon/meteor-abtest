Meteor.startup ->
  Template.abtests.created = ->
    Meteor.subscribe "ABTests"

  Template.abtests.helpers
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
      values = []
      for alternative of this.values
        values.push
          name: alternative
          started: this.values[alternative].started
          finished: this.values[alternative].finished
          rank: this.values[alternative].rank
      for v in values.sort((a, b) -> a.rank - b.rank)
        started = v.started
        finished = v.finished
        finishedRate = if started then finished * 100 / started else 0
        item =
          isControl: not control
          isSignificant: ->
            return false if not this.control or (this.finished < 10 and this.control.finished < 10)
            n = this.finished + this.control.finished
            d = Math.abs this.finished - this.control.finished
            Math.pow(d, 2) >  n
          name: v.name
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
      if this.isSignificant() then "YES" else "NO"

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
  Template.abtests.events
    'click #resetTest': ->
      if confirm("Are you sure you want to delete test: \n#{this.name}")
        ABTest.reset this.name