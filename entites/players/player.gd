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
@export var handposition2:Marker2D
@export var fart_sound:AudioStreamPlayer2D
enum deaths{DROWN,WEAPON,BLAST,ALIVE}
var deathby:deaths=deaths.ALIVE
var body_list:Array
var fart_knockback_strength =400
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
var tilemap_layer:TileMapLayer
var attackable:bool=false
var picked_body
var pickable:bool
var target_body
@export var drown_sound:AudioStreamPlayer2D
var select_range: int =15
var last_facing_dir:Vector2=Vector2(-1,0)
func _physics_process(delta: float) -> void:

	Global.tile_selected_pos=throwposition.global_position
	Global.player_pos=global_position
	pickup_box.position=throwposition.position
	animation_handler()
	movement(delta)
	attack()
	#pick_handler()
	state_handler()
	tile_death_checker()
	move_and_slide()
func tile_death_checker():
	if tilemap_layer!=null:
		var player_tile_coords=tilemap_layer.local_to_map(Global.player_pos)
		var death_prop=tilemap_layer.get_cell_tile_data(player_tile_coords)
		if death_prop:
			if not death_prop.get_custom_data("Tile_deadly"):
				deathby=deaths.DROWN
				on_death()
				
		else:
				deathby=deaths.DROWN
				on_death()
func on_death():
	var object_coords = tilemap_layer.local_to_map(global_position)
	#print("martoy")
	
	if Global.player_aliveable:
		drown_sound.pitch_scale=randf_range(0,1)
		
			
		Global.player_picked=false	
		
		match  deathby:
			deaths.DROWN:
				var body=void_killed_particles_scene.instantiate()
				body.emitting=true
				if not drown_sound.playing:
					drown_sound.playing=true
				velocity*=0.7
				add_child(body)
				
				for i in range(10):
					await get_tree().create_timer(1/24).timeout
					scale.x-=0.1
					scale.y-=0.1
				await get_tree().create_timer(0.5).timeout
		
		
		queue_free()
		Global.player_aliveable=false
		
func state_handler():
	var direction :Vector2 = Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	Input.get_action_strength("down")-Input.get_action_strength("up"))
	if Global.player_aliveable:
		if	velocity!=Vector2.ZERO:
			Global.player_state=Global.player_states.RUN
		elif velocity==Vector2.ZERO:
			Global.player_state=Global.player_states.IDLE
	
		
	
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
	Input.get_action_strength("down")-Input.get_action_strength("up")).normalized()
	var throw_dir : Vector2=Vector2(Input.get_action_strength("throw_right")-Input.get_action_strength("throw_left")
	,Input.get_action_strength("throw_down")-Input.get_action_strength("throw_up"))
	if throw_dir!=Vector2.ZERO and Global.player_aliveable:
		throwposition.position=select_range*throw_dir.normalized()
	if direction!=Vector2.ZERO and Global.player_aliveable:		
		if velocity.length()<=Global.player_max_speed:
			
			velocity=(direction*Global.player_speed)
		else:
			velocity=(direction*Global.player_max_speed)
	else:
		if velocity.length()>10:
			velocity*=0.9
		else:
			velocity=Vector2.ZERO
func throw_object()->void:
	
	if picked_body!=null:
		if picked_body is weapon:
			picked_body.rotation=throwposition.get_angle_to(position)
		if Input.is_action_just_pressed("pick"):
			picked_body.picked=false	
			if picked_body is weapon:
				picked_body.collision_disabler()	
			picked_body.reparent(get_parent())
			picked_body.global_position=Global.tile_selected_pos.round()
			Global.player_picked=false
			picked_body=null
		#elif Input.is_action_just_pressed("shoot") and picked_body is weapon:
		if Input.is_action_just_pressed("fire") and picked_body is spear:
			picked_body.picked=false
			picked_body.reparent(get_parent())
			picked_body.returable=true
			picked_body.player=self
			picked_body.fire(self.global_position.direction_to(throwposition.global_position))
			Global.player_picked=false
			picked_body=null
		if Input.is_action_pressed("shoot") and picked_body is weapon:
			
			if picked_body.throw_force<500:
								
					await  get_tree().create_timer(0.5).timeout
					if picked_body:
						picked_body.scale.x-=0.01
						picked_body.throw_force+=20
			
		if Input.is_action_just_released("shoot") and picked_body is weapon:
			picked_body.scale.x=1
			picked_body.picked=false
			picked_body.reparent(get_parent())
			picked_body.throwable=true	
			picked_body.dir=self.global_position.direction_to(throwposition.global_position)
			Global.player_picked=false
			picked_body=null
func pick_handler()->void:
	if (pickable and Input.is_action_just_pressed("pick") and not Global.player_picked
	 and self.velocity.length()==0):
		Global.player_picked=true
		target_body.picked=true
		
		if target_body is Pickable:
			target_body.reparent(handposition)
			target_body.linear_velocity=Vector2.ZERO
			target_body.angular_velocity=0.0
			target_body.rotation=0
			target_body.position=handposition.position
		elif target_body is weapon:
			target_body.collision_disabler()
			target_body.reparent(handposition2)
			target_body.velocity=Vector2.ZERO
			target_body.position=handposition2.position
			
		picked_body=target_body
		
		
		
		
	elif Global.player_picked :
		throw_object()
func _on_pickupbox_body_entered(body: Node2D) -> void:
	if body :
		pickable=true
		target_body=body
func _on_pickupbox_body_exited(body: Node2D) -> void:
	if body :
		pickable=false # Replace with function body.
		target_body=null
		


func _on_attackrange_body_entered(body: Node2D) -> void:
	if body:
		
		
		if body is football_ai:
			body_list.append(body)
		else:
			body_list.append(body)
		

func _on_attackrange_body_exited(body: Node2D) -> void:
	if body:
		for i in range(body_list.size()):
			if body_list[i-1]==body:
				body_list.remove_at(i-1)
		
		#attacked_body=null
func attack():
	if Input.is_action_just_pressed("select") :
		fart_particle.emitting=true	
		if fart_sound.playing==false:
			fart_sound.playing=true
		
		if body_list!=null:
			for i in body_list:
				#print(body_list)
				var attacked_body=i
				
				var dir = self.global_position.direction_to(attacked_body.global_position)
				if attacked_body is Pickable:
					attacked_body.linear_velocity=dir*fart_knockback_strength
				elif attacked_body is football_ai:
					print("attacked")
					attacked_body.velocity+=dir*fart_knockback_strength
				else:
					attacked_body.velocity=dir*fart_knockback_strength
		
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is weapon_hurtbox:
		deathby=deaths.WEAPON
		on_death()
