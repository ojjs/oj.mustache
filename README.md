# oj.mustache

A mustache plugin for oj. In a perfect world you wouldn't need mustache when you have oj. Well the world isn't perfect. Good luck out there.

## Usage

    oj.mustache """
      <html>
        <body>
          Hi, my name is {{name}}. My twitter handle is @{{twitter}}
        </body>
      </html>
    """, name: 'Evan', twitter:'evanmoran'

Note: You can pass the arguments in any order. Objects will be unioned into a view. The string will be assumed to be a template.

## Docs

[ojjs.org/plugins#mustache](http://ojjs.org/plugins#mustache)

