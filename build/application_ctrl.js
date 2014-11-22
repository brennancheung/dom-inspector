(function() {
  angular.module('dom-nav').controller('ApplicationCtrl', function($scope) {
    return $scope.dom = "<html>\n    <head>\n        <title>Awesomeness!</title>\n    </head>\n    <body>\n        <h1>Hello World</h1>\n        <!-- do not show me -->\n        <p class=\"testing\">\n            This is a <b>test</b> of mixed text and tags\n        </p>\n        <div>\n            <div>Testing</div>\n        </div>\n        <ul id=\"listing\">\n            <li>one</li>\n            <li>two</li>\n        </ul>\n    </body>\n</html>";
  });

}).call(this);
