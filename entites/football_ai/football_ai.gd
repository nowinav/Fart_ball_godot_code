class_name football_ai  extends CharacterBody2D
var tilemap_layer:TileMapLayer
var target:Vector2
var body_list:Array
var speed :int =90
var goal_pos:Vector2
var attackable:bool
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
@export var fart_particles:CPUParticles2D
var dir_bool:bool=true
@export var raycast:RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target=Global.puck_pos
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
func tile_checker():
	var pos=tilemap_layer.local_to_map(global_position)
	var data= tilemap_layer.get_cell_tile_data(pos)
	if data:
		if not data.get_custom_data("object_alive"):
			on_death()
func ray_handler():
	
	raycast.look_at(goal_pos)
	if raycast.is_colliding():
		attack()
func dir_handler():
	#print("handling")
	if not dir_bool:
		await get_tree().create_timer(1).timeout
		dir_bool=true
func _physics_process(delta: float) -> void:
	ray_handler()
	if attackable:
		attackable=false
		await  get_tree().create_timer(1).timeout
		attack()
		
	if tilemap_layer:
		tile_checker()
	
	var dir:Vector2
	dir = self.global_position.direction_to(target)
	if target.distance_to(global_position)>15 :
		
		if dir_bool:
			dir_bool=false
			dir_handler()
			velocity=dir*speed
			
			
	
	
	move_and_slide()
func attack():
	for i in body_list:
		var dir =global_position.direction_to(i.global_position)
		if i is Pickable:
			fart_particles.emitting=true	
			i.linear_velocity+=200*dir
		elif i is Player:
			i.velocity+=200*dir
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
