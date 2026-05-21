extends Node2D
class_name level
var player_spawnable:bool=true
var beer = preload("res://entites/beer/beer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn(beer,Vector2(30,0))# Replace with function body.
	
func spawn_player(spawncoords:Vector2):
	var player_scene=preload("res://entites/players/player.tscn")
	var player = player_scene.instantiate()
	player.global_position=spawncoords
	
	
	add_child(player)
func spawn(object_scene:PackedScene,position:Vector2 = Vector2.ZERO):
	var object=object_scene.instantiate()
	object.global_position=position
	add_child(object)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select") and player_spawnable:
		player_spawnable=false
		spawn_player(Vector2.ZERO)
