class_name weapon extends CharacterBody2D
var tilemap_layer:TileMapLayer
var throw_force: int=100
var picked:bool
var dir:Vector2
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
var friction_coeff:float=0.9
var throwable:bool
@export var collision_shape:CollisionShape2D
func throw(dir):
		velocity+=dir*throw_force
		throwable=false
		collision_shape.disabled=true
		z_index=2
		z_as_relative=false
		for i in range(5):
			await get_tree().create_timer(0.05).timeout
			scale.x+=0.1
			scale.y+=0.1
		for i in range(5):
			await get_tree().create_timer(0.05).timeout
			scale.x-=0.1
			scale.y-=0.1
		z_as_relative=true
		collision_shape.disabled=false
		throw_force=10
		
func collision_disabler():
	if picked:
		collision_shape.disabled=true
	else:
		collision_shape.disabled=false
func friction_handler():
	if velocity.length()>0.2:
		velocity*=friction_coeff
	else:
		velocity=Vector2.ZERO

func _process(delta: float) -> void:
	tile_checker()
	
func _physics_process(delta: float) -> void:
	if throwable:
		throw(dir)
	move_and_slide()
func tile_checker():
	var object_coords = tilemap_layer.local_to_map(global_position)
	var data= tilemap_layer.get_cell_tile_data(object_coords)
	if not picked:
		if data:
			if not data.get_custom_data("object_alive"):
				on_death()
		else:
			on_death()
func on_death():
	picked=false
	collision_shape.disabled=true
	var body=void_killed_particles_scene.instantiate()
	body.emitting=true
	
	for i in range(10):
		await get_tree().create_timer(1/24).timeout
		scale.x-=0.1
		scale.y-=0.1
	add_child(body)
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
