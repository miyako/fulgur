---
layout: default
---

![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/fulgur)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/fulgur/total)

# Generate PDF from HTML

### Using static `html` input

```4d
var $fulgur : cs.fulgur
$fulgur:=cs.fulgur.new()

var $task : Object
$task:={\
    input: "<!DOCTYPE html>\n<html lang=\"en\">\n<body>\n<h1>Hello</h1>\n<img src=\"logo.png\" alt=\"Logo with border\" class=\"bordered\" style=\"width:40px;height:40px\">\n</body>\n</html>\n"; \
    title: "test"; \
    font: []; \
    css: [File("/DATA/style.css")]; \
    image: [{name: "logo.png"; file: File("/DATA/logo.png")}]; \
    margin: "10 10 10 10"; \
    landscape: False; \
    size: "A4"; \
    data: {}; \
    output: Folder(fk desktop folder).file("test.pdf")}

$fulgur.render($task)
```

### Using `jinja2` template and `json` data

```4d
var $css : 4D.File
$css:=File("/DATA/invoice.css")

var $template : 4D.File
$template:=File("/DATA/invoice.html")

var $fulgur : cs.fulgur
$fulgur:=cs.fulgur.new()

var $data : 4D.File
$data:=File("/DATA/data.json")

var $output : 4D.File
$output:=Folder(fk desktop folder).file("invoice.pdf")

var $task : Object
    $task:={\
    input: $template; \
    title: "test"; \
    font: []; \
    css: [$css]; \
    image: [{name: "logo.png"; file: File("/DATA/logo.png")}]; \
    margin: "10 10 10 10"; \
    landscape: True; \
    size: "A4"; \
    data: $data; \
    output: $output; context: $output}

$fulgur.render($task; Formula(onResponse))
```

<img width="1101" height="598" alt="example" src="/fulgur/assets/example.png" />

