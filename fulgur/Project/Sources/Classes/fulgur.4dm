property fulgur : cs:C1710._fulgur

Class constructor($class : 4D:C1709.Class)
	
	var $controller : 4D:C1709.Class
	var $superclass : 4D:C1709.Class
	$superclass:=$class.superclass
	$controller:=cs:C1710._CLI_Controller
	
	While ($superclass#Null:C1517)
		If ($superclass.name=$controller.name)
			$controller:=$class
			break
		End if 
		$superclass:=$superclass.superclass
	End while 
	
	This:C1470.fulgur:=cs:C1710._fulgur.new("fulgur"; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.workers.first()
	
Function get workers() : Collection
	
	If (This:C1470.fulgur=Null:C1517)
		return 
	End if 
	
	return This:C1470.fulgur.controller.workers
	
Function terminate()
	
	If (This:C1470.fulgur=Null:C1517)
		return 
	End if 
	
	This:C1470.fulgur.controller.terminate()
	
Function render($option : Variant; $formula : 4D:C1709.Function) : Collection
	
	If (This:C1470.fulgur=Null:C1517)
		return 
	End if 
	
	var $stdOut; $stdIn; $isAsync : Boolean
	var $options : Collection
	var $results : Collection
	$results:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
		Else 
			$options:=[]
	End case 
	
	var $commands : Collection
	$commands:=[]
	
	If (OB Instance of:C1731($formula; 4D:C1709.Function))
		$isAsync:=True:C214
		//once
		If (This:C1470.fulgur.controller._onResponse=Null:C1517)
			Use (This:C1470.fulgur.controller)
				This:C1470.fulgur.controller._onResponse:=$formula
			End use 
		End if 
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is object:K8:27)
			continue
		End if 
		
		$stdOut:=Not:C34(OB Instance of:C1731($option.output; 4D:C1709.File))
		
		$command:=This:C1470.fulgur.escape(This:C1470.fulgur.executablePath)
		$command+=" render "
		
		If ($option.margin#Null:C1517) && (Value type:C1509($option.margin)=Is text:K8:3) && ($option.margin#"")
			$command+=" --margin "
			$command+=This:C1470.fulgur.escape($option.margin)
		End if 
		
		If ($option.landscape#Null:C1517) && (Value type:C1509($option.landscape)=Is boolean:K8:9) && ($option.landscape)
			$command+=" --landscape "
		End if 
		
		If ($option.size#Null:C1517) && (Value type:C1509($option.size)=Is text:K8:3) && ($option.size#"")
			$command+=" --size "
			$command+=This:C1470.fulgur.escape($option.size)
		End if 
		
		If ($option.title#Null:C1517) && (Value type:C1509($option.title)=Is text:K8:3) && ($option.title#"")
			$command+=" --title "
			$command+=This:C1470.fulgur.escape($option.title)
		End if 
		
		If ($option.font#Null:C1517) && (Value type:C1509($option.font)=Is collection:K8:32)
			var $font : Variant
			For each ($font; $option.font)
				If ($font=Null:C1517) || (Value type:C1509($font)#Is object:K8:27) || (Not:C34(OB Instance of:C1731($font; 4D:C1709.File))) || (Not:C34($font.exists))
					continue
				End if 
				$command+=" --font "
				$command+=This:C1470.fulgur.escape(This:C1470.fulgur.expand($font).path)
			End for each 
		End if 
		
		
		If ($option.css#Null:C1517) && (Value type:C1509($option.css)=Is collection:K8:32)
			var $css : Variant
			For each ($css; $option.css)
				If ($css=Null:C1517) || (Value type:C1509($css)#Is object:K8:27) || (Not:C34(OB Instance of:C1731($css; 4D:C1709.File))) || (Not:C34($css.exists))
					continue
				End if 
				$command+=" --css "
				$command+=This:C1470.fulgur.escape(This:C1470.fulgur.expand($css).path)
			End for each 
		End if 
		
		If ($option.image#Null:C1517) && (Value type:C1509($option.image)=Is collection:K8:32)
			var $image : Variant
			For each ($image; $option.image)
				If ($image=Null:C1517) || (Value type:C1509($image)#Is object:K8:27)
					continue
				End if 
				If (Value type:C1509($image.name)#Is text:K8:3) || ($image.name="")
					continue
				End if 
				If (Value type:C1509($image.file)#Is object:K8:27) || (Not:C34(OB Instance of:C1731($image.file; 4D:C1709.File))) || (Not:C34($image.file.exists))
					continue
				End if 
				$command+=" --image "
				$command+=This:C1470.fulgur.escape($image.name)
				$command+="="
				$command+=This:C1470.fulgur.escape(This:C1470.fulgur.expand($image.file).path)
			End for each 
		End if 
		
		If (Not:C34($stdOut))
			$command+=" --output "
			$command+=This:C1470.fulgur.escape(This:C1470.fulgur.expand($option.output).path)
			If ($option.output.exists)
				$option.output.delete()
			End if 
			$option.output.parent.create()
		Else 
			$command+=" --output - "
		End if 
		
		If (Value type:C1509($option.input)=Is object:K8:27) || (Value type:C1509($option.input)=Is BLOB:K8:12) || (Value type:C1509($option.input)=Is text:K8:3)
			$stdIn:=True:C214
		End if 
		
		var $in : Variant
		
		Case of 
			: (Value type:C1509($option.data)=Is object:K8:27) && (OB Instance of:C1731($option.data; 4D:C1709.File)) && ($option.data.exists)
				$command+="--data "
				$command+=This:C1470.fulgur.escape(This:C1470.fulgur.expand($option.data).path)
			: ((Value type:C1509($option.data)=Is object:K8:27) || (Value type:C1509($option.data)=Is BLOB:K8:12)) && (Not:C34($stdIn))
				$command+="--data - "
				$in:=$option.data
			: (Value type:C1509($option.data)=Is text:K8:3)
				$command+="--data  "
				$command+=This:C1470.fulgur.escape($option.data)
		End case 
		
		Case of 
			: (Value type:C1509($option.input)=Is object:K8:27) && (OB Instance of:C1731($option.input; 4D:C1709.File)) && ($option.input.exists)
				$command+=This:C1470.fulgur.escape(This:C1470.fulgur.expand($option.file).path)
			: ($stdIn)
				$command+=" --stdin "
				$in:=$option.input
		End case 
		
		//SET TEXT TO PASTEBOARD($command)
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.fulgur.controller.execute($command; $stdIn ? $in : Null:C1517; $option.context).worker.worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If (Not:C34($isAsync))
			If ($stdOut)
				$results.push($worker.response)
			Else 
				$results.push(Null:C1517)
			End if 
		End if 
		
	End for each 
	
	If (Not:C34($isAsync))
		return $results
	End if 