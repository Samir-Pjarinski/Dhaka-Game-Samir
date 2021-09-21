extends Area
#samir

var areaDoorEntered = false
var doorOpened = false


func _process(delta):
	if Input.is_action_just_pressed("ui_use"):
		if areaDoorEntered == true:
			
			if doorOpened == false:
				$Spatial.rotate_y(rad2deg(90))
				doorOpened = true
				print("open")
				
			elif doorOpened == true:
				$Spatial.rotate_y(rad2deg(-90))
				doorOpened = false
				print("close")

func _on_Area_body_entered(body):
	if body.name == "Player":
		areaDoorEntered = true

func _on_Area_body_exited(body):
	if body.name == "Player":
		areaDoorEntered = false
