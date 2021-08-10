extends Spatial

## Todo - 
## Fix

var move = 0.005
var rise = false

func _ready():
	pass

func _process(delta):
	if rise == true:
		if translation.y < -0.26 or translation.y >= 2.5:
			move*=-1
#			print("rise")
			print(translation.y, ",", move)
		translation.y+=move

func _on_Area_body_entered(body):
	if body is KinematicBody:
		rise = true

func _on_Area_body_exited(body):
	if body is KinematicBody:
		rise = false
