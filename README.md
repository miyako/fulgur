# fulgur

[**Fulgur**](https://github.com/mitsuru/fulgur) is a modern, lightweight alternative to `wkhtmltopdf` written in Rust. 

> [!NOTE]
> the CLI is **not** a direct replacement for `wkhtmltopdf`. It is designed primarily as a template engine (jinja) and strictly offline, meaning `href` are generally not allowed.

The component includes `3` executables:

- macOS Apple Silicon/Intel, code signed and notarised
- Windows Intel/ARM

## Example 

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

#### Template genereate by Claude

https://claude.ai/share/c9d16499-5cbb-4fe1-88ee-59796543bd15

