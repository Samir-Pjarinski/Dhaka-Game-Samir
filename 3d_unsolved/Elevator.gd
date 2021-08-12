extends Spatial

## Todo - 
## Fix

var move = 0.005
var rise = false
var ground
var top

func _ready():
	pass

func _process(delta):
	if rise == true:
		if translation.y < ground or translation.y >= top:
			move*=-1
#			print("rise")
			print(translation.y, ",", move)
		translation.y+=move

func _on_Area_body_entered(body):
	if body is KinematicBody:
		get_tree().call_group("Player", "El_values")
		print("up")

func rise(ground, top):
	rise == true
