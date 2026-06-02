class_name Pickable extends RigidBody2D

@export var collision: CollisionShape2D
var tilemap_layer:TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func tile_checker():
	var object_coords = tilemap_layer.local_to_map(global_position)
	var data= tilemap_layer.get_cell_tile_data(object_coords)
	if data:
		if not data.get_custom_data("object_alive"):
			on_death()
	else:
		on_death()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tile_checker()
	if Global.player_picked:
		collision.disabled=true
		set_physics_process(false)
		
	else:
		collision.disabled=false
		set_physics_process(true)
		
func on_death():
	scale.x-=0.5
	scale.y-=0.5
	linear_velocity*=10
	await get_tree().create_timer(0.1).timeout
	
	queue_free()
func _physics_process(delta: float) -> void:
	linear_velocity*=0.9
	if linear_velocity.length()>100:
		linear_velocity=Vector2.ZERO
