extends CharacterBody2D
class_name Player
@export var animationplayer: AnimationPlayer
@export var animation_tree: AnimationTree
@export var sprite: Sprite2D
@export var camera: Camera2D
@export var handposition: Marker2D
@export var throwposition: Marker2D
@export var pickup_box:Area2D
@export var fart_particle: CPUParticles2D

var tilemap_layer:TileMapLayer
var attacked_body : Pickable
var attackable:bool=false
var picked_body: Pickable
var pickable:bool
var target_body: Pickable
var select_range: int =15
var last_facing_dir:Vector2=Vector2(-1,0)
func _physics_process(delta: float) -> void:
	Global.tile_selected_pos=throwposition.global_position
	pickup_box.position=throwposition.position
	animation_handler()
	movement(delta)
	attack()	
	pick_handler()
	state_handler()
	tile_death_checker()
	move_and_slide()
func tile_death_checker():
	var player_tile_coords=tilemap_layer.local_to_map(Global.player_pos)
	var death_prop=tilemap_layer.get_cell_tile_data(player_tile_coords)
	if death_prop:
		if not death_prop.get_custom_data("Tile_deadly"):
			on_death()
			
	else:
			on_death()
func on_death():
	
	await get_tree().create_timer(0.25).timeout
	Global.player_aliveable=false
func state_handler():
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	if Global.player_aliveable:
		if	velocity!=Vector2.ZERO:
			Global.player_state=Global.player_states.RUN
		elif velocity==Vector2.ZERO:
			Global.player_state=Global.player_states.IDLE
	else:
		queue_free()
		
	
func animation_handler():
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	
	if   abs(direction.x)>0:
		last_facing_dir=direction.normalized()
	animation_tree.set("parameters/conditions/idle",Global.player_state==Global.player_states.IDLE)
	animation_tree.set("parameters/conditions/run",Global.player_state==Global.player_states.RUN)
	animation_tree.set("parameters/Run/blend_position",last_facing_dir.x)
	animation_tree.set("parameters/idle/blend_position",last_facing_dir .x)
func movement(delta):
	Global.player_pos=self.global_position
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	
	
	var throw_dir : Vector2=Vector2(Input.get_action_strength("throw_right")-Input.get_action_strength("throw_left")
	,Input.get_action_strength("throw_down")-Input.get_action_strength("throw_up"))
	if throw_dir!=Vector2.ZERO:
		throwposition.position=select_range*throw_dir.normalized()
	if direction!=Vector2.ZERO:		
		if velocity.length()<=Global.player_max_speed:
			velocity+=delta*direction*Global.player_speed
		else:
			velocity=direction*Global.player_max_speed
	else:
			velocity=Vector2.ZERO
func throw_object()->void:
	if picked_body!=null:
		picked_body.reparent(get_parent())
		picked_body.global_position=Global.tile_selected_pos.round()
		Global.player_picked=false
		picked_body=null
		
func pick_handler()->void:
	if pickable and Input.is_action_just_pressed("pick") and not Global.player_picked and self.velocity.length()==0:
		Global.player_picked=true
		
		target_body.reparent(handposition)
		target_body.linear_velocity=Vector2.ZERO
		target_body.angular_velocity=0.0
		target_body.rotation=0
		target_body.position=handposition.position
		
		picked_body=target_body
		
		
		
		
	elif Input.is_action_just_pressed("pick") and Global.player_picked :
		throw_object()
func _on_pickupbox_body_entered(body: Node2D) -> void:
	if body is Pickable:
		pickable=true
		target_body=body
func _on_pickupbox_body_exited(body: Node2D) -> void:
	if body is Pickable:
		pickable=false # Replace with function body.
		target_body=null
		


func _on_attackrange_body_entered(body: Node2D) -> void:
	if body is Pickable:
		
		attackable=true
		attacked_body=body


func _on_attackrange_body_exited(body: Node2D) -> void:
	if body is Pickable:
		attackable=false
		attacked_body=null
func attack():
	if Input.is_action_just_pressed("select") and attackable:
		var dir = self.global_position.direction_to(attacked_body.global_position)
		attacked_body.linear_velocity+=dir*100
		fart_particle.emitting=true	
		print("attack")
