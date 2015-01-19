class ABTestServer
  @adminIds = []

Meteor.publish "ABTests", ->
  if ABTestServer.adminIds is '*' or this.userId in ABTestServer.adminIds
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

  resetAbTest: (name) ->
    if ABTestServer.adminIds is '*' or  Meteor.userId() in ABTestServer.adminIds
      ABTests.remove { name: name }