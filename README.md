meteor-abtest
=============

Simple AB testing framework for Meteor (modeled after Rails' split).

Usage
-----

```
$ meteor add manuel:abtest
```

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
  showRoundButton: -> ABTest.start('Landing Button', ['Normal', 'Round']) is 'Round'
```
```
Template.landing.events
  'click button': -> ABTest.finish('Landing Button')
```

Displaying the info
-------------------

***On the Client***

```
{{> abtests }}
```

***On the Server***

Specify the Meteor IDs of the users who have permission to view the data.
```
ABTestServer.adminIds = ['user 1 id', 'user 2 id', 'user n id']
```

***Example***

![meteor-abtest](https://cloud.githubusercontent.com/assets/4257750/2920902/9cfde158-d6ec-11e3-9ec1-a424378970b3.png)

Tracking Users
--------------
This library uses localStorage to keep track of the users. If localStorage is not available it uses cookies and if that fails it uses a session variable.

ABTests collection
------------------
You'll probably never need to do this but if you want you can query the ABTests collection.

***ABTests.find() Example***

```
{
	"_id" : "536a9a2c6935af1b3f0eec6d",
	"name" : "Welcome Message",
	"values" : {
		"Join Now" : {
			"started" : 15051,
			"finished" : 3827
		},
		"Get Started" : {
			"started" : 14984,
			"finished" : 3583
		}
	}
}
{
	"_id" : "536bd11553e89d2e75bd3cda",
	"name" : "Landing Improvements",
	"values" : {
		"Normal" : {
			"started" : 72919,
			"finished" : 67481
		},
		"With Header" : {
			"started" : 72880,
			"finished" : 66554
		},
		"Expanded View" : {
			"started" : 73057,
			"finished" : 68062
		},
		"Header + Expanded" : {
			"started" : 73376,
			"finished" : 68164
		}
	}
}

```