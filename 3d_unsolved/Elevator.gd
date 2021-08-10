extends Spatial

var move = 0.005
var rise = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
