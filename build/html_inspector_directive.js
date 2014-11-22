(function() {
  angular.module('dom-nav').directive('htmlInspector', function($timeout) {
    return {
      restrict: 'AE',
      scope: {
        dom: '='
      },
      templateUrl: 'html_inspector.html',
      link: function(scope, element, attrs, controller) {
        var setNodeSelected;
        setNodeSelected = function(node, selected, recursive) {
          var child, _i, _len, _ref, _results;
          if (recursive == null) {
            recursive = true;
          }
          node.selected = selected;
          if (recursive) {
            _ref = node.children;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              child = _ref[_i];
              _results.push(setNodeSelected(child, selected, recursive));
            }
            return _results;
          }
        };
        scope.toggleNodeSelected = function(node) {
          return setNodeSelected(node, !node.selected);
        };
        return scope.$watch('dom', function(newValue, oldValue) {
          var buildTree, exception, html;
          try {
            html = $($.parseXML(newValue)).context.children[0];
            scope.title = "HTML Inspector";
            scope.valid = true;
            scope.label = "Label";
            buildTree = function(node) {
              var child, processedChild, result, _i, _len, _ref;
              if (node.nodeType === node.COMMENT_NODE) {
                return null;
              }
              result = {
                "private": false,
                children: [],
                value: node.nodeValue,
                expanded: true,
                selected: false
              };
              switch (node.nodeType) {
                case node.COMMENT_NODE:
                  return null;
                case node.ELEMENT_NODE:
                  result.folder = true;
                  result.tag = node.nodeName;
                  result["private"] = node.nodeName === 'head';
                  _ref = node.childNodes;
                  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    child = _ref[_i];
                    processedChild = buildTree(child);
                    if (processedChild) {
                      result.children.push(processedChild);
                    }
                  }
                  break;
                case node.TEXT_NODE:
                  if (!/\S/.test(node.nodeValue)) {
                    return null;
                  }
                  result.file = true;
                  result.value = node.nodeValue.trim();
              }
              return result;
            };
            return scope.node = buildTree(html);
          } catch (_error) {
            exception = _error;
            return scope.valid = false;
          }
        });
      }
    };
  });

}).call(this);
