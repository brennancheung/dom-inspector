angular.module('dom-nav').controller 'ApplicationCtrl', ($scope) ->
    $scope.dom = """
<html>
    <head>
        <title>Awesomeness!</title>
    </head>
    <body>
        <h1>Hello World</h1>
        <!-- do not show me -->
        <p class="testing">
            This is a <b>test</b> of mixed text and tags
        </p>
        <div>
            <div>Testing</div>
        </div>
        <ul id="listing">
            <li>one</li>
            <li>two</li>
        </ul>
    </body>
</html>
"""
