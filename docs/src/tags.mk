---
title: Tags
---

Monk supports an extensible, indentation-based syntax for generating arbitrary HTML:

    :tag [arguments] [.class] [#id] [&attr] [attr="value"]
        block content
        block content
        ...

A tagged block opens with a header line containing a colon, a tag, and, optionally, a set of attributes. The block's content then consists of all subsequent blank or indented lines following the header.

The block's content can be indented by any number of spaces; the common indent is stripped and the first non-indented line ends the block. Leading and trailing blank lines are also trimmed from the content.

To take a simple example, the markup below:

    :div
        This is a paragraph.

generates the following HTML:

    <div>
        <p>This is a paragraph.</p>
    </div>

A block header can contain a single ID, any number of classes, and any number of named attributes. Block syntax also allows for one or more arguments to be supplied (whether these are used depends on the tag). So the markup below:

    :div .foo .bar #baz
        This is a paragraph.

generates the following HTML:

    <div class="foo bar" id="baz">
        <p>This is a paragraph.</p>
    </div>

Boolean attributes can be specified using an `&` symbol, e.g. `&checked`. Attributes with values can be specified without quotes as long as the value does not contain spaces, e.g.

    :div attr1=foo attr2="bar baz"

A block's tag determines how its content is processed. In  general blocks can be nested to any depth and can contain any block-level content, e.g. the markup below:

    :div .outer
        :div .inner
            This is a paragraph.

will generate the following HTML:

    <div class="outer">
        <div class="inner">
            <p>This is a paragraph.</p>
        </div>
    </div>

By default, all unregistered tags are rendered like the `:div` tag above.

A subset of HTML tags do not behave like the `:div` tag and require special processing. *Leaf* tags like paragraphs and headings and *inline* tags like `:a` and `:span` cannot contain nested block-level content; *void* tags like `:input` and `:hr` cannot contain any content at all. All tags with registered handlers are listed below.

Monk also supports a set of custom tags with no HTML equivalents, e.g. the `:alert` tag for creating alert boxes. All custom tags are listed below.

Note that a tag can have one or more aliases which are treated identically, e.g. the tag `:blockquote` and the sigil `:>>` both create a `<blockquote>` element in the HTML output. Tags with registered aliases are listed below.



## Tag Reference


#### `:a`

    :a <url>

Creates an `<a>` element. The link's url may be supplied as a keyword argument. Links are inline elements and do not support nested block-level content.


#### `:alert`

    :alert [ info | warning | error ]
    :!! [ info | warning | error ]

Creates an alert box --- a `<div>` element with the class `alertbox` which can be styled appropriately using CSS. Keywords are added as classes. This tag supports nested block-level content.


#### `:blockquote`

    :blockquote
    :>>

Creates a `<blockquote>` element. This tag supports nested block-level content.


#### `:button`

    :button

Creates a `<button>` element. This is an inline element and does not support nested block-level content.


#### `:comment`

    :comment
    :htmlcomment

Creates a HTML comment. The block's content is not processed any further but is included in the output in its raw state.


#### `:h1 ... :h6`

    :h1 [||]

Creates a heading element of the specified level. Headings are leaf elements and do not support nested block-level content.

Heading tags support an optional `||` argument which turns on newline-to-linebreak mode for the heading's content.


#### `:hr`

    :hr

Creates a horizontal rule. A horizontal rule is a void element and cannot contain content of any sort.


#### `:ignore`

    :ignore

Instructs Monk to ignore the block's content. This tag can be used to add comments to a document that will not appear in the rendered output.


#### `:img`

    :img <src-url> [link-url]

Block-level alternative to the inline image tag. The block's content is used as the image's `alt` text.

The image's `src` url may be supplied as a keyword argument. If a second url is supplied as a keyword argument, the image will be wrapped in a link pointing to this url. (In this case any attribute arguments will be applied to the outer link element rather than to the inner image.)


#### `:input`

    :input <type>

Creates an `<input>` element. This is a void element which cannot contain content of any sort. The element's type may be supplied as a keyword argument.


#### `:label`

    :label

Creates a `<label>` element. This is an inline element and does not support nested block-level content.


#### `:nl2br`

    :nl2br
    :||

Turns on newline-to-linebreak mode. All nested content will have newlines converted to `<br>` tags.


#### `:null`

    :null
    :<<

A `:null` block has no HTML representation of its own; instead it passes its attributes on to its immediate children. This tag supports nested block-level content.


#### `:p`

    :p [||]

Creates a paragraph element. Paragraphs are leaf elements and do not support nested block-level content.

The `p` tag supports an optional `||` argument which turns on newline-to-linebreak mode for the paragraph's content.

    :p ||
        These linebreaks
        will be preserved.


#### `:pre`

    :pre [language]
    ::: [language]

Creates a `<pre>` element. Accepts an optional argument specifying the language of the code.

If a language is specified then a `lang-<language>` class and a `data-lang="<language>"` attribute are added to the `<pre>` element.

If a language is specified and the [Pygments](http://pygments.org) package is installed then syntax highlighting can be applied to the code sample. This feature is turned off by default but can be enabled by supplying a `pygmentize=True` keyword argument to the `render()` function:

::: python

    >>> html = monk.render(text, pygmentize=True)


#### `:raw`

    :raw

Indicates that the block contains content which should not be processed any further but should be included in the output in its raw state.


#### `:script`

    :script

Creates a `<script>` element. The block's content is not processed any further but is included in the output in its raw state.


#### `:span`

    :span

Creates a `<span>` element. This is an inline element and does not support nested block-level content.


#### `:style`

    :style

Creates a `<style>` element. The block's content is not processed any further but is included in the output in its raw state.


#### `:textarea`

    :textarea

Creates a `<textarea>` element. This is an inline element and does not support nested block-level content.


#### `:time`

    :time

Creates a `<time>` element. This is an inline element and does not support nested block-level content.


#### `:++`

    :++

This sigil indicates that the block contains a simple table literal in the one of the following formats:

    foo | bar | baz      foo | bar | baz
    ---------------      ---------------
    aaa | bbb | ccc      aaa | bbb | ccc      aaa | bbb | ccc      aaa | bbb | ccc
    ddd | eee | fff      ddd | eee | fff      ddd | eee | fff      ddd | eee | fff
    ---------------                           ---------------
    foo | bar | baz                           foo | bar | baz

Header and footer lines are optional. Note that all the tables above can be 'boxed' with decorative outer lines of pipes and dashes, e.g.:

    ---------------      -------------------
    foo | bar | baz      | foo | bar | baz |
    ---------------      -------------------
    aaa | bbb | ccc      | aaa | bbb | ccc |
    ddd | eee | fff      | ddd | eee | fff |
    ---------------      -------------------

Column alignment can be specified using colons as below:

    default | left | center | right
    ------- | :--- | :----: | ----:
     aaaaa  |  bb  |  cccc  |  ddd
     eeeee  |  ff  |  gggg  |  hhh

Cells in the left column above receive the class `left`, cells in the center column receive the class `center`, and cells in the right column receive the class `right`.

Attributes specified in the block header will be applied to the `<table>` element.
