(function() {
  angular.module('dom-nav', []);

  angular.module('dom-nav').config(function() {});

  angular.module('dom-nav').run(function() {
    return console.log("App started.  Prepare for awesomeness!");
  });

  angular.module('dom-nav').filter('yaml', function() {
    return function(input) {
      return jsyaml.dump(input, {
        indent: 2
      });
    };
  });

  angular.module('dom-nav').filter('truncateString', function() {
    return function(input, length) {
      if (length == null) {
        length = 5;
      }
      if (typeof input !== 'string') {
        return input;
      }
      if (input.length < length) {
        return input;
      }
      return input.slice(0, length) + "...";
    };
  });

}).call(this);
