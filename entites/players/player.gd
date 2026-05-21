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
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	
	movement(delta)
	pick_handler()
	move_and_slide()

func movement(delta):
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	if direction!=Vector2.ZERO:
		#throwposition.position=direction
		
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
		picked_body.global_position=throwposition.global_position
		picked_body.throw(throw_direction)
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
		
