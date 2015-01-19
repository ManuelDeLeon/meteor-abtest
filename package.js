Package.describe({
    summary: "Simple AB testing framework for Meteor.",
    version: "1.0.1",
    git: "https://github.com/ManuelDeLeon/meteor-abtest"
});

Package.onUse(function(api) {
    api.versionsFrom('METEOR@0.9.2.2');
    api.use('coffeescript', ['client', 'server']);
    api.use('templating', 'client');

    api.add_files(['abtest-client.coffee'], 'client');
    api.add_files(['abtest-server.coffee'], 'server');
    api.add_files(['abtest-both.coffee'], ['client', 'server']);

    api.add_files(['abtest-dashboard.coffee', 'abtest-dashboard.html'], 'client');

    api.export('ABTest');
    api.export('ABTestServer');
});