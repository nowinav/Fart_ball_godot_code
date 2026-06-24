class_name football_ai  extends CharacterBody2D
var tilemap_layer:TileMapLayer
var target:Vector2
var ballmarker_1:Vector2
var ballmarker_2:Vector2
var body_list:Array
var speed :int =Global.football_ai_speed
var goal_pos:Vector2
var attackable:bool
var dribalable:bool
var marker:Vector2
@export var animation_player:AnimationPlayer
@export var dir_ray:RayCast2D
@export var raycast_ball: RayCast2D
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
@export var fart_particles:CPUParticles2D
var dir_bool:bool=true
var dir: Vector2
enum states{Chase,Defend,Dribble}
var state
var ball_to_ai:Vector2
var tangent : Vector2
var fric_coeff=0.9
var spawn_timeabe:bool
@export var raycast:RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	spawn_timeabe=true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	ballmarker_1=Global.ballmarker_2
	animation_handler()
	ballmarker_2=Global.ballmarker_3
	target=Global.marker_pos
	if Global.puck_alive==false:
		target=Vector2.ZERO
func on_death():
	if Global.football_ai_alive:
		var body=void_killed_particles_scene.instantiate()
		for i in range(10):
			await get_tree().create_timer(1/24).timeout
			scale.x-=0.1
			scale.y-=0.1
		add_child(body)
		queue_free()
		Global.football_ai_alive=false
func smarth_rotation(pos:Vector2):
	ball_to_ai=global_position-pos
	
	var clockwise = Vector2(-ball_to_ai.y, ball_to_ai.x)
	var counter = Vector2(ball_to_ai.y, -ball_to_ai.x)
	if tile_checker_general(target):
		if clockwise.dot(ball_to_ai)>counter.dot(ball_to_ai):
			velocity = clockwise.normalized() * speed
		else:
			velocity = counter.normalized() * speed
	else:
		attack()
func animation_handler():
	if velocity.length()>0:
		if velocity.x>0:
			animation_player.play("football_ai_right")
		else:
			animation_player.play("football_ai_left")
	else:
		animation_player.play("idle")
func state_handler():
	

	if target.distance_to(goal_pos)>512 and global_position.distance_to(Global.puck_pos)>100:
		state=states.Defend
	else:
		state=states.Chase
	state_giver()
func state_giver():
	match state:
		states.Chase:
			chase()
		states.Defend:
			defend()
func marker_handler():
	pass
	#if dribalable:
		#if global_position.distance_to(ballmarker_1)>global_position.distance_to(ballmarker_2):
			#marker=ballmarker_2
		#elif global_position.distance_to(ballmarker_1)<=global_position.distance_to(ballmarker_2):
			#marker=ballmarker_1
			#
	#else:
		#marker=target
	
func defend():
	
	dir=global_position.direction_to(Global.puck_pos)
	velocity=dir*speed
	
func Dribble():
	pass
func chase():
	
	if not raycast.is_colliding()and  raycast_ball.is_colliding():
		smarth_rotation(raycast_ball.get_collision_point())
	else:
		
		velocity=dir*speed
	
func tile_checker_general(position:Vector2):
	var pos=tilemap_layer.local_to_map(position)
	var data= tilemap_layer.get_cell_tile_data(pos)
	if data:
		if not data.get_custom_data("object_alive"):
			return false
		else:
			return true
func tile_checker():
	var pos=tilemap_layer.local_to_map(global_position)
	var data= tilemap_layer.get_cell_tile_data(pos)
	if data:
		if not data.get_custom_data("object_alive"):
			on_death()
func ray_handler():
	raycast_ball.look_at(Global.puck_pos)
	raycast.look_at(goal_pos)
	dir_ray.look_at(target)
	if raycast.is_colliding():
		attack()
func dir_handler():
	if not dir_bool:
		await get_tree().create_timer(1).timeout
		dir=global_position.direction_to(Global.puck_pos)
		dir_bool=true
func _physics_process(delta: float) -> void:
	velocity*=fric_coeff
	#dir_handler()
	if not Global.puck_alive:
		velocity=Vector2.ZERO
	if spawn_timeabe:
		spawn_timeabe=false
		
	tile_checker()
	state_handler()
	ray_handler()
	dir=global_position.direction_to(Global.marker_pos)
			
			
	
	
	move_and_slide()
func attack():
	for i in body_list:
		var dir =global_position.direction_to(i.global_position)
		fart_particles.emitting=true
		if i is Pickable:
				
			i.linear_velocity=400*dir
		elif i is Player:
			
			i.velocity=200*dir
func _on_attackrange_body_entered(body: Node2D) -> void:
	if body:
		body_list.append(body)
		if body is Player:
			attackable=true

func _on_attackrange_body_exited(body: Node2D) -> void:
	if body:
		for i in body_list.size():
			if body==body_list[i-1]:
				body_list.remove_at(i-1)
