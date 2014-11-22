angular.module('dom-nav').directive 'htmlEditor', ($timeout) ->
    restrict: 'AE'
    scope:
        dom: '='
    template: '<div></div>'
    link: (scope, element, attrs, controller) ->
        editorOptions =
            lineNumbers:     true
            styleActiveLine: true
            matchTags:
                bothTags:    true
            indentUnit:      4
            mode:            "text/html"
            keyMap:          "vim"
            vimMode:         true
            showCursorWhenSelecting: true
        codeMirror = CodeMirror element[0], editorOptions

        # scope.dom won't be populated when the directive is first linked.
        # We need to populate it after the fact.
        # However, since codeMirror.onChange will trigger a scope chain we don't want a circular update.
        # So only set it the first time.
        initialized = false
        scope.$watch 'dom', (newValue, oldValue) ->
            return if initialized
            initialized = true
            codeMirror.setValue newValue

        codeMirror.on 'change', ->
            # The digest is currently running in the above scope.$watch.
            # We need to use $timeout instead of $apply to break out of digest.
            # $timeout also will perform a $digest when it runs.
            $timeout ->
               scope.dom = codeMirror.getValue()
            , 0
