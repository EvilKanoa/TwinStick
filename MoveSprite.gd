extends AnimatedSprite


func _ready():
	animation = "idle"
	rotation = 0


func move(rotation, acceleration):
	if animation != "moving":
		animation = "moving"
		$MovementParticles2D.restart()
		$MovementParticles2D.emitting = true
	self.rotation = rotation
	$MovementParticles2D.process_material.scale = acceleration * 2 + 1


func idle():
	if animation != "idle":
		animation = "idle"
		$MovementParticles2D.emitting = false
