//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//execute in a worker to process callbacks
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $css : 4D:C1709.File
	$css:=File:C1566("/DATA/invoice.css")
	
	var $template : 4D:C1709.File
	$template:=File:C1566("/DATA/invoice.html")
	
	var $fulgur : cs:C1710.fulgur
	$fulgur:=cs:C1710.fulgur.new()
	
	var $data : 4D:C1709.File
	$data:=File:C1566("/DATA/data.json")
	
	var $output : 4D:C1709.File
	$output:=Folder:C1567(fk desktop folder:K87:19).file("invoice.pdf")
	
	var $task : Object
	$task:={\
		input: $template; \
		title: "test"; \
		font: []; \
		css: [$css]; \
		image: [{name: "logo.png"; file: File:C1566("/DATA/logo.png")}]; \
		margin: "10 10 10 10"; \
		landscape: True:C214; \
		size: "A4"; \
		data: $data; \
		output: $output; context: $output}
	
	$fulgur.render($task; Formula:C1597(onResponse))
	
End if 

//callbacks will fire only if we exit the method