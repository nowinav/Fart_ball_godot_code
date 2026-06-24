extends Node2D
@export var tilemap_layer:TileMapLayer
@export var goal1_pos:Marker2D
@export var goal2_pos:Marker2D
@export var ball_pos:Marker2D
@export var player1_pos:Marker2D
@export var player2_pos:Marker2D
@export var score:Label
func _ready() -> void:
	Global.reset()
	spawn(preload("res://objects/goal/goal.tscn"),goal1_pos.global_position,2)
	spawn(preload("res://objects/goal/goal.tscn"),goal2_pos.global_position,1)
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO,type:int=0):
	print(spawncoords)
	var body=body_scene.instantiate()
	if body is Pickable:
		body.tilemap_layer=tilemap_layer
		body.goal=goal1_pos
	elif body is Player:
		body.tilemap_layer=tilemap_layer
	elif body is weapon:
		body.tilemap_layer=tilemap_layer
	elif body is football_ai:
		body.tilemap_layer=tilemap_layer
		body.goal_pos=goal1_pos.global_position
	elif body is goal:
		body.type=type
	body.global_position=spawncoords
	self.add_child(body)
func puck_spawn_handler():
	if not Global.puck_alive:
		Global.puck_alive=true
		spawn(preload("res://entites/pickable_item/pickable_item.tscn"))
func football_ai_spawn_handler():
	if not Global.football_ai_alive:
		Global.football_ai_alive=true
		await get_tree().create_timer(0.2).timeout
		
		spawn(preload("res://entites/football_ai/football_ai.tscn"),player2_pos.global_position)
func player_spawn_handler():
	if not Global.player_aliveable :
		Global.player_aliveable=true
		spawn(preload("res://entites/players/player.tscn"),player1_pos.global_position)
		
func _process(delta: float) -> void:
	score.text=str(Global.player1goals)+"-"+str(Global.player2goals)
	player_spawn_handler()
	puck_spawn_handler()
	football_ai_spawn_handler()
