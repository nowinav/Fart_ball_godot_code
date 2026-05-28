class_name level extends Node2D

var player_scene=preload("res://entites/players/player.tscn")
# Called when the node enters the scene tree for the first time.
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO):
	var body=body_scene.instantiate()
	body.global_position=spawncoords
	self.add_child(body)
func _ready() -> void:
	spawn(player_scene)
	spawn(preload("res://entites/pickable_item/pickable_item.tscn"),Vector2(30,0))
