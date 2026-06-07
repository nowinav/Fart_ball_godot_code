class_name weapon extends CharacterBody2D
var tilemap_layer:TileMapLayer
var picked:bool
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
var friction_coeff:float=0.9
@export var collision_shape:CollisionShape2D
func collision_disabler():
	if picked:
		collision_shape.disabled=true
	else:
		collision_shape.disabled=false
func friction_handler():
	if velocity.length()>5:
		velocity*=friction_coeff
	else:
		velocity=Vector2.ZERO
func _physics_process(delta: float) -> void:
	friction_handler()
func _process(delta: float) -> void:
	tile_checker()
	collision_disabler()
	
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
