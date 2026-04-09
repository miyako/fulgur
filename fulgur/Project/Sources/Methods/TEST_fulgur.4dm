//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//execute in a worker to process callbacks
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $css : 4D:C1709.File
	$css:=File:C1566("/DATA/invoice.css")
	
	var $template : 4D:C1709.File
	$template:=File:C1566("/DATA/invoice.html.jinja2")
	
	var $fulgur : cs:C1710.fulgur
	$fulgur:=cs:C1710.fulgur.new()
	
	var $task : Object
	$task:={\
		input: "<!DOCTYPE html>\n<html lang=\"en\">\n<body>\n<h1>Hello</h1>\n<img src=\"logo.png\" alt=\"Logo with border\" class=\"bordered\" style=\"width:40px;height:40px\">\n</body>\n</html>\n"; \
		title: "test"; \
		font: []; \
		css: [File:C1566("/DATA/style.css")]; \
		image: [{name: "logo.png"; file: File:C1566("/DATA/logo.png")}]; \
		margin: "10 10 10 10"; \
		landscape: False:C215; \
		size: "A4"; \
		data: {}; \
		output: Folder:C1567(fk desktop folder:K87:19).file("test.pdf")}
	
	$fulgur.render($task)
	
End if 

//callbacks will fire only if we exit the method