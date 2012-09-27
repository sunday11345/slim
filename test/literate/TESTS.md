# Slim test suite

## Line indicators

In this section we test all line indicators.

### Text blocks `|`

#### Simple

A text blocks starts with the `|` as line indicator.

~~~ slim
| Text block
~~~

renders as

~~~ html
Text block
~~~

#### Multiline

Multiple lines can be indented beneath the first text line.

~~~ slim
|  Text
    block

     with

    multiple
   lines
~~~

renders as

~~~ html
 Text
  block

   with

  multiple
 lines
~~~

#### First line determines indentation

The first line of a text block determines the indentation.

~~~ slim
|

   Text
    block

     with

    multiple
   lines
~~~

renders as

~~~ html
Text
 block

  with

 multiple
lines
~~~

### Text blocks with trailing whitespace `'`

#### Simple

A text blocks with trailing whitespace starts with the `'` as line indicator.

~~~ slim
' Text block
~~~

renders as

~~~ html
Text block 
~~~

#### Multiline

Multiple lines can be indented beneath the first text line.

~~~ slim
'  Text
    block

     with

    multiple
   lines
~~~

renders as

~~~ html
 Text
  block

   with

  multiple
 lines 
~~~

#### First line determines indentation

The first line of a text block determines the indentation.

~~~ slim
'

   Text
    block

     with

    multiple
   lines
~~~

renders as

~~~ html
Text
 block

  with

 multiple
lines 
~~~

### Inline HTML `<`

#### Simple

HTML can be written directly.

~~~ slim
<a href="http://slim-lang.com">slim-lang.com</a>
~~~

renders as

~~~ html
<a href="http://slim-lang.com">slim-lang.com</a>
~~~

#### HTML allows nesting

HTML tags allow nested blocks inside.

~~~ slim
<html>
  head
    title Example
  body
    - if true
      | yes
    - else
      | no
</html>
~~~

renders as

~~~ html
<html><head><title>Example</title></head><body>yes</body></html>
~~~

### Control code `-`

#### Simple

The dash `-` denotes arbitrary control code.

~~~ slim
- greeting = 'Hello, World!'
- if false
  | Not true
- else
  = greeting
~~~

renders as

~~~ html
Hello, World!
~~~

#### Line breaks

Complex code can be broken with backslash `\`.

~~~ slim
- greeting = 'Hello, '+\
     \
    'World!'
- if false
  | Not true
- else
  = greeting
~~~

~~~ html
Hello, World!
~~~

### Dynamic output `=`

#### Simple

The equal sign `=` produces dynamic output.

~~~ slim
= 7*7
~~~

~~~ html
49
~~~

#### HTML escaping

Dynamic output is escaped by default.

~~~ slim
= '<script>evil();</script>'
~~~

~~~ html
&lt;script&gt;evil();&lt;/script&gt;
~~~
