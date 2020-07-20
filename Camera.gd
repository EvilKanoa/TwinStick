extends Camera2D


var target = null


func _physics_process(_delta):
	if target != null:
		position = target.position
