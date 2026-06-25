extends Node2D
@export var tilemap_layer:TileMapLayer
@export var goal1_pos:Marker2D
@export var goal2_pos:Marker2D
@export var ball_pos:Marker2D
@export var player1_pos:Marker2D
@export var player2_pos:Marker2D
@export var score:Label
@export var time:Label
@export var camer:Camera2D
@export var game_timer: Timer
@export var celeb_mark1:Marker2D
@export var celeb_mark2:Marker2D
@export var celeb_mark3:Marker2D
@export var celeb_mark4:Marker2D
@export var celeb_mark5:Marker2D
@export var celeb_mark6:Marker2D
@export var celeb_node:Node2D
var celeb_mark_list:Array=[]
var time_value:int
var player_node:Player
var football_ai_1:football_ai
var football_ai_2:football_ai
var player_scene=preload("res://entites/players/player.tscn")
var football_ai_scene=preload("res://entites/football_ai/football_ai.tscn")
var puck_scene=preload("res://entites/pickable_item/pickable_item.tscn")

	
func particles_on():
	for i in range(5):
		celeb_node.get_child(i).emitting=true
func _ready() -> void:
	particles_on()
	if not Global.tutorial:
		game_timer.start(Global.match_time_left)
	Global.reset()
	spawn(preload("res://objects/goal/goal.tscn"),goal1_pos.global_position,2)
	spawn(preload("res://objects/goal/goal.tscn"),goal2_pos.global_position,1)
func camera_handler():
	if player_node!=null and football_ai_1!=null:
		#print("heil")
		var avg=(player_node.global_position+football_ai_1.global_position)/2
		camer.global_position=avg
		if player_node.global_position.distance_to(football_ai_1.global_position)<200:
			if camer.zoom.length()<=Vector2(2,2).length():
				await get_tree().create_timer(1/24).timeout
				camer.zoom+=Vector2(0.1,0.1)
		else:
			camer.zoom=Vector2(1,1)
	elif football_ai_1!=null and football_ai_2!=null:
		var avg=(football_ai_2.global_position+football_ai_1.global_position)/2
		camer.global_position=avg
		if football_ai_2.global_position.distance_to(football_ai_1.global_position)<200:
			if camer.zoom.length()<=Vector2(2,2).length():
				await get_tree().create_timer(1/24).timeout
				camer.zoom+=Vector2(0.1,0.1)
				
		else:
			camer.zoom=Vector2(1,1)
	else:
		for i in [football_ai_1,player_node,football_ai_2]:
			if i:
				camer.global_position=i.global_position
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO,type:int=0):
	#print(spawncoords)
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
		if football_ai_1==null:
			football_ai_1=body
			body.goal_pos=goal1_pos.global_position
		elif football_ai_2==null :
			body.goal_pos=goal2_pos.global_position
			football_ai_2=body
			football_ai_2.speed+=10
		body.tilemap_layer=tilemap_layer
		
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
	Global.match_time_left=game_timer.time_left
	time.text="Time:"+str(snapped(game_timer.time_left,0.1))
	score.text="SCORE:"+str(Global.player1goals)+"-"+str(Global.player2goals)
	player_spawn_handler()
	puck_spawn_handler()
	if Global.tutorial==false:
		football_ai_spawn_handler()
	camera_handler()
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().paused=not get_tree().paused


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://levels/main_menu/finalscreen.tscn")
