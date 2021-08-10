extends Area

var areaDoorEntered = false
var doorOpened = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _process(delta):
	if Input.is_action_just_pressed("ui_use"):
		print("in1")
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