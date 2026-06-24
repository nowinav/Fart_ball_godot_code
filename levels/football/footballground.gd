extends Node2D
@export var tilemap_layer:TileMapLayer
@export var goal1_pos:Marker2D
@export var goal2_pos:Marker2D
@export var ball_pos:Marker2D
@export var player1_pos:Marker2D
@export var player2_pos:Marker2D
@export var score:Label
@export var camer:Camera2D
var player_node:Player
var football_ai_1:football_ai

var player_scene=preload("res://entites/players/player.tscn")
var football_ai_scene=preload("res://entites/football_ai/football_ai.tscn")
var puck_scene=preload("res://entites/pickable_item/pickable_item.tscn")
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	Global.reset()
	spawn(preload("res://objects/goal/goal.tscn"),goal1_pos.global_position,2)
	spawn(preload("res://objects/goal/goal.tscn"),goal2_pos.global_position,1)
func camera_handler():
	if player_node!=null and football_ai_1!=null:
		print("heil")
		var avg=(player_node.global_position+football_ai_1.global_position)/2
		camer.global_position=avg
		if player_node.global_position.distance_to(football_ai_1.global_position)<50:
			camer.zoom=Vector2(2,2)
		else:
			camer.zoom=Vector2(1,1)
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO,type:int=0):
	print(spawncoords)
	var body=body_scene.instantiate()
	if body is Pickable:
		body.tilemap_layer=tilemap_layer
		body.goal=goal1_pos
	elif body is Player:
		body.tilemap_layer=tilemap_layer
		player_node=body
		print(player_node)
	elif body is weapon:
		body.tilemap_layer=tilemap_layer
	elif body is football_ai:
		football_ai_1==body
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
		
		spawn(football_ai_scene,player2_pos.global_position)
func player_spawn_handler():
	if not Global.player_aliveable :
		Global.player_aliveable=true
		spawn(player_scene,player1_pos.global_position)
		
func _process(delta: float) -> void:
	
	score.text=str(Global.player1goals)+"-"+str(Global.player2goals)
	player_spawn_handler()
	puck_spawn_handler()
	football_ai_spawn_handler()
	camera_handler()
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().paused=not get_tree().paused
