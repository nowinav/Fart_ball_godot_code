class_name level extends Node2D
@export var tilemap_layer:TileMapLayer
var roomsize:Vector2
var player_scene=preload("res://entites/players/player.tscn")
const TILEDATA : Dictionary={
	"floor":{"source_id":0,"atlas_coords":Vector2(1,7)},
	"ceiling":{"source_id":0,"atlas_coords":Vector2(1,9)}
}
# Called when the node enters the scene tree for the first time.
func player_spawn_handler():
	if not Global.player_aliveable and Input.is_action_just_pressed("pick"):
		spawn(player_scene)
		Global.player_aliveable=true
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO):
	var body=body_scene.instantiate()
	if body is Pickable:
		body.tilemap_layer=tilemap_layer
	elif body is Player:
		body.tilemap_layer=tilemap_layer
	body.global_position=spawncoords
	self.add_child(body)
func _ready() -> void:
	roomsize=Vector2(randi_range(10,20),randi_range(10,20))
	room_gen(Vector2.ZERO,roomsize)	
	spawn(preload("res://entites/pickable_item/pickable_item.tscn"),Vector2(30,0))
func room_gen(pos:Vector2,size :Vector2):
	var	tile_array:Array=[]
	for x in range(pos.x-size.x/2,pos.x+size.x/2):
		for y in range(pos.y-size.y/2,pos.y+size.y/2):
			tile_array.append(Vector2(x,y))
			
	tilemap_layer.set_cells_terrain_connect(tile_array,0,0)
func tile_death_checker():
	var player_tile_coords=tilemap_layer.local_to_map(Global.player_pos)
	var death_prop=tilemap_layer.get_cell_tile_data(player_tile_coords)
	if death_prop:
		if not death_prop.get_custom_data("Tile_deadly"):
			Global.player_aliveable=false
			
	else:
			Global.player_aliveable=false
			
func object_tile_checker(pos:Vector2):
	var object_coords=tilemap_layer.local_to_map(pos)
	
func _process(delta: float) -> void:
	player_spawn_handler()
	
