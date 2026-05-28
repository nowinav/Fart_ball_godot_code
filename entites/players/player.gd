extends CharacterBody2D
class_name Player
@export var animationplayer: AnimationPlayer
@export var animation_tree: AnimationTree
@export var sprite: Sprite2D
@export var camera: Camera2D
@export var handposition: Marker2D
@export var throwposition: Marker2D
var picked_body: Pickable
var pickable:bool
var target_body: Pickable
var select_range: int =20
var last_facing_dir:Vector2=Vector2(-1,0)
func _physics_process(delta: float) -> void:
	Global.tile_selected_pos=throwposition.global_position
	animation_handler()
	movement(delta)
	pick_handler()
	
	move_and_slide()
func animation_handler():
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	var idle=!velocity.normalized()
	if  not idle and abs(direction.x)>0:
		last_facing_dir=direction.normalized()

	animation_tree.set("parameters/Run/blend_position",last_facing_dir.x)
	animation_tree.set("parameters/Idle/blend_position",last_facing_dir .x)
func movement(delta):
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	
	
	var throw_dir : Vector2=Vector2(Input.get_action_strength("throw_right")-Input.get_action_strength("throw_left")
	,Input.get_action_strength("throw_down")-Input.get_action_strength("throw_up"))
	if throw_dir!=Vector2.ZERO:
		throwposition.position=select_range*throw_dir
	if direction!=Vector2.ZERO:		
		if velocity.length()<=Global.player_max_speed:
			velocity+=delta*direction*Global.player_speed
		else:
			velocity=direction*Global.player_max_speed
	else:
		velocity*=0.8
	
func throw_object()->void:
	if picked_body!=null:
		picked_body.reparent(get_parent())
		var throw_direction=global_position.direction_to(throwposition.global_position)
		picked_body.global_position=Global.tile_selected_pos.round()
		Global.player_picked=false
		picked_body=null
		print("thrown")
func pick_handler()->void:
	if pickable and Input.is_action_just_pressed("pick") and not Global.player_picked:
		Global.player_picked=true
		target_body.reparent(handposition)
		target_body.position=handposition.position
		
		picked_body=target_body
		print("picked")
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
		
