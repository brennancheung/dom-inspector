(function() {
  angular.module('dom-nav').directive('htmlEditor', function($timeout) {
    return {
      restrict: 'AE',
      scope: {
        dom: '='
      },
      template: '<div></div>',
      link: function(scope, element, attrs, controller) {
        var codeMirror, editorOptions, initialized;
        editorOptions = {
          lineNumbers: true,
          styleActiveLine: true,
          matchTags: {
            bothTags: true
          },
          indentUnit: 4,
          mode: "text/html",
          keyMap: "vim",
          vimMode: true,
          showCursorWhenSelecting: true
        };
        codeMirror = CodeMirror(element[0], editorOptions);
        initialized = false;
        scope.$watch('dom', function(newValue, oldValue) {
          if (initialized) {
            return;
          }
          initialized = true;
          return codeMirror.setValue(newValue);
        });
        return codeMirror.on('change', function() {
          return $timeout(function() {
            return scope.dom = codeMirror.getValue();
          }, 0);
        });
      }
    };
  });

}).call(this);
