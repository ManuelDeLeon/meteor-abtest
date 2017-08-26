Package.describe({
  name: "manuel:abtest",
  summary: "Simple AB testing framework for Meteor.",
  version: "1.1.0",
  git: "https://github.com/ManuelDeLeon/meteor-abtest"
});

Package.onUse(function(api) {
  api.versionsFrom("METEOR@1.0");
  api.use("mongo");
  api.use("coffeescript", ["client", "server"]);
  api.use("templating", "client");

  api.addFiles(["abtest-client.coffee"], "client");
  api.addFiles(["abtest-dashboard.coffee", "abtest-dashboard.html"], "client");
  api.addFiles(["abtest-both.coffee"], ["client", "server"]);
  api.addFiles(["abtest-server.coffee"], "server");

  api.export("ABTest");
  api.export("ABTestServer");
});
