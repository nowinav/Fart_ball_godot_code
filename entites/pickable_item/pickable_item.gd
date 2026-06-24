class_name Pickable extends RigidBody2D
var void_killed_particles_scene:PackedScene =preload("res://common/particle2d/void_killed_particles.tscn")
@export var collision: CollisionShape2D
@export var node:Node2D
@export var mark:Marker2D
@export var mark_2:Marker2D
@export var mark_3:Marker2D
var tilemap_layer:TileMapLayer
var picked:bool
var drowned:bool
var friction_coeff:float=0.95
var goal:Marker2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func tile_checker():
	if tilemap_layer:
		var object_coords = tilemap_layer.local_to_map(global_position)
		var data= tilemap_layer.get_cell_tile_data(object_coords)
		if not picked:
			if data:
				if data.get_custom_data("goal"):
					on_death()
					drowned=false
					
				if not data.get_custom_data("object_alive"):
					drowned=true
					on_death()
						
			else:
				drowned=true
				on_death()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.ballmarker_2=mark_2.global_position
	Global.ballmarker_3=mark_3.global_position
	Global.marker_pos=mark.global_position
	Global.puck_pos=self.global_position
	if goal:
		node.look_at(goal.global_position)
	tile_checker()
	if picked:
		collision.disabled=true
		set_physics_process(false)
		
	else:
		collision.disabled=false
		set_physics_process(true)
		
func on_death():
	if Global.puck_alive:
		picked=false
		collision.disabled=true
		var body=void_killed_particles_scene.instantiate()
		body.emitting=true
		linear_velocity*=0.1
		if drowned:
			for i in range(10):
				await get_tree().create_timer(1/24).timeout
				scale.x-=0.1
				scale.y-=0.1
			add_child(body)
		else:
			for i in range(10):
				await get_tree().create_timer(1/24).timeout
				scale.x+=1
				scale.y+=1
			
		
		await get_tree().create_timer(0.5).timeout
		
		
		queue_free()
		Global.puck_alive=false
func _physics_process(delta: float) -> void:
	linear_velocity*=friction_coeff
	if linear_velocity.length()>1000:
		linear_velocity=Vector2.ZERO
