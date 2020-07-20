extends Node2D


onready var map_limits_target := $NavigationTileMap
const Round = preload("res://Round.tscn")


func get_map_limits():
	var used_rect = map_limits_target.get_used_rect()
	return {
		"position": used_rect.position * map_limits_target.cell_size,
		"end": used_rect.end * map_limits_target.cell_size,
	}
	


func _on_Player_round_fired(shooter, position, direction, power):
	var rnd = Round.instance()
	add_child(rnd)
	rnd.shooter = shooter
	rnd.shoot(position, direction, power)
