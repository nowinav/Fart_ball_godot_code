class_name Pickable extends RigidBody2D
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
@export var collision: CollisionShape2D
var tilemap_layer:TileMapLayer
var picked:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func tile_checker():
	var object_coords = tilemap_layer.local_to_map(global_position)
	var data= tilemap_layer.get_cell_tile_data(object_coords)
	if not picked:
		if data:
			if not data.get_custom_data("object_alive"):
				on_death()
		else:
			on_death()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tile_checker()
	if picked:
		collision.disabled=true
		set_physics_process(false)
		
	else:
		collision.disabled=false
		set_physics_process(true)
		
func on_death():
	picked=false
	collision.disabled=true
	var body=void_killed_particles_scene.instantiate()
	body.emitting=true
	
	for i in range(10):
		await get_tree().create_timer(1/24).timeout
		scale.x-=0.1
		scale.y-=0.1
	add_child(body)
	
	linear_velocity*=10
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
func _physics_process(delta: float) -> void:
	linear_velocity*=0.9
	if linear_velocity.length()>100:
		linear_velocity=Vector2.ZERO
