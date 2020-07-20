extends Node



onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera1
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2
onready var level = $Viewports/ViewportContainer1/Viewport1/Level
onready var map_limits = level.get_map_limits()

func _ready():
	set_camera_targets()
	set_camera_limits()


func set_camera_targets():
	viewport2.world_2d = viewport1.world_2d
	
	camera1.target = level.get_node("Player1")
	camera2.target = level.get_node("Player2")


func set_camera_limits():
	camera1.limit_left = map_limits.position.x
	camera1.limit_right = map_limits.end.x
	camera1.limit_top = map_limits.position.y
	camera1.limit_bottom = map_limits.end.y
	camera2.limit_left = map_limits.position.x
	camera2.limit_right = map_limits.end.x
	camera2.limit_top = map_limits.position.y
	camera2.limit_bottom = map_limits.end.y
