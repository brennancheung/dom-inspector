angular.module('dom-nav').directive 'htmlInspector', ($timeout) ->
    restrict: 'AE'
    scope:
        dom: '='
    templateUrl: 'html_inspector.html'
    link: (scope, element, attrs, controller) ->
        setNodeSelected = (node, selected, recursive=true) ->
            node.selected = selected
            if recursive
                for child in node.children
                    setNodeSelected child, selected, recursive

        scope.toggleNodeSelected = (node) ->
            setNodeSelected node, !node.selected

        scope.$watch 'dom', (newValue, oldValue) ->
            # Unfortunately $("some html here") won't parse 'html', 'head', or 'body' tags.
            # We can get around this by converting it to raw XML.
           try
                html = $($.parseXML(newValue)).context.children[0]
                scope.title = "HTML Inspector"
                scope.valid = true
                scope.label = "Label"

                # build a folder / file tree
                buildTree = (node) ->
                    return null if node.nodeType is node.COMMENT_NODE

                    result =
                        private:     false
                        children:    []
                        value:       node.nodeValue
                        expanded:    true
                        selected:    false

                    switch node.nodeType
                        when node.COMMENT_NODE
                            return null

                        when node.ELEMENT_NODE
                            result.folder = true
                            result.tag = node.nodeName
                            result.private = node.nodeName is 'head'
                            for child in node.childNodes
                                processedChild = buildTree child
                                result.children.push processedChild if processedChild

                        when node.TEXT_NODE
                            # don't include empty text nodes that contain only whitespace
                            return null unless /\S/.test(node.nodeValue)
                            result.file = true
                            # not technically accurate but much better usability
                            result.value = node.nodeValue.trim()

                    return result

                scope.node = buildTree html

           catch exception
                # HTML will sometimes be invalid when the user is typing.
                # No need to show obnoxious error messages in the console.
                # Let the Inspector tell the user there is an error.
                scope.valid = false
