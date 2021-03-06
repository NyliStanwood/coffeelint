module.exports = class JSLintReporter

    constructor: (@errorReport, options = {}) ->
        { @quiet } = options

    print: (message) ->
        # coffeelint: disable=no_debugger
        console.log message
        # coffeelint: enable=no_debugger

    publish: () ->
        @print '<?xml version="1.0" encoding="utf-8"?><jslint>'

        for path, errors of @errorReport.paths
            if errors.length
                @print "<file name=\"#{path}\">"

                for e in errors when not @quiet or e.level is 'error'
                    # continue if @quiet and e.level isnt 'error'

                    @print """
                    <issue line="#{e.lineNumber}"
                            lineEnd="#{e.lineNumberEnd ? e.lineNumber}"
                            reason="[#{@escape(e.level)}] #{@escape(e.message)}"
                            evidence="#{@escape(e.context)}"/>
                    """
                @print '</file>'

        @print '</jslint>'

    escape: (msg) ->
        # Force msg to be a String
        msg = '' + msg
        unless msg
            return
        # Perhaps some other HTML Special Chars should be added here
        # But this are the XML Special Chars listed in Wikipedia
        replacements = [
            [/&/g, '&amp;']
            [/"/g, '&quot;']
            [/</g, '&lt;']
            [/>/g, '&gt;']
            [/'/g, '&apos;']
        ]

        for r in replacements
            msg = msg.replace r[0], r[1]

        msg
