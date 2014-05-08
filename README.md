meteor-abtest
=============

Simple AB testing framework for Meteor.

It's modeled after Rails' split.

It uses localStorage to keep track of the users. If localStorage is not available it uses cookies and if that fails it uses a session variable.

Usage
-----

```
ABTest.start("Test Name", ['Alternative 1', 'Alternative 2', 'Alternative n'])
```
It returns one of the alternatives to be used.

```
ABTest.finish("Test Name")
```
Concludes the test for this user.

**Example**
```
Template.landing.helpers
  showRoundButton: -> ABTest.start('Landing Button', ['Normal (boxed)', 'New (round)']) is 'New (round)'
```
```
Template.landing.events
  'click button': -> ABTest.finish('Landing Button')
```

Displaying the info
-------------------

***On the Client***

```
{{> abtestDashboard }}
```

***On the Server***

Specify the Meteor IDs of the users who have permission to view the data.
```
ABTestServer.adminIds = ['user 1 id', 'user 2 id', 'user n id']
```

***Example***

![meteor-abtest](https://cloud.githubusercontent.com/assets/4257750/2920902/9cfde158-d6ec-11e3-9ec1-a424378970b3.png)