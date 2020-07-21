extends Node2D


onready var map_limits_target := $NavigationTileMap


func get_map_limits():
	var used_rect = map_limits_target.get_used_rect()
	return {
		"position": used_rect.position * map_limits_target.cell_size,
		"end": used_rect.end * map_limits_target.cell_size,
	}


func _on_WeaponFactory_round_fired(round_node):
	add_child(round_node)
