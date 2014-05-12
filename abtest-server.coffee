class ABTestServer
  @adminIds = []

Meteor.publish "ABTests", ->
  if this.userId in ABTestServer.adminIds
    ABTests.find()

Meteor.methods
  startAbTest: (name, value, order) ->
    increment = {}
    increment["values.#{value}.finished"] = 0
    increment["values.#{value}.started"] = 1
    rank = {}
    rank["values.#{value}.rank"] = order

    ABTests.update { name: name }, { $set: rank, $inc: increment }, { upsert: true }

  finishAbTest: (name, value) ->
    increment = {}
    increment["values.#{value}.finished"] = 1
    ABTests.update { name: name }, { $inc: increment }