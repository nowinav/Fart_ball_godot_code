class_name level extends Node2D
@export var tilemap_layer:TileMapLayer
@export var tilemap_layer2:TileMapLayer
var roomsize:Vector2
var player_scene=preload("res://entites/players/player.tscn")
var ocean_dim:Vector2
var sand_tile_coords:Array=[Vector2(0,0),Vector2(1,0),Vector2(2,0)]
var water_tile_coords:Array=[Vector2(3,0),Vector2(6,0)]
const TILEDATA : Dictionary={
	"floor":{"source_id":0,"atlas_coords":Vector2(1,7)},
	"ceiling":{"source_id":0,"atlas_coords":Vector2(1,9)}
}
# Called when the node enters the scene tree for the first time.
func player_spawn_handler():
	if not Global.player_aliveable :
		spawn(player_scene)
		Global.player_aliveable=true
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO):
	var body=body_scene.instantiate()
	if body is Pickable:
		body.tilemap_layer=tilemap_layer
	elif body is Player:
		body.tilemap_layer=tilemap_layer
	elif body is weapon:
		body.tilemap_layer=tilemap_layer
	body.global_position=spawncoords
	self.add_child(body)
func _ready() -> void:
	player_spawn_handler()
	roomsize=Vector2(randi_range(20,50),randi_range(20,50))
	ocean_dim=roomsize+Vector2(40,40)
	room_gen(roomsize,sand_tile_coords,3,false,Vector2.ZERO,Vector2(4,4))
	ocean_gen(ocean_dim,water_tile_coords,3,Vector2.ZERO)
	spawn(preload("res://entites/pickable_item/pickable_item.tscn"),Vector2(30,0))
	spawn(preload("res://objects/spear/spear.tscn"),Vector2(-30,0))
func ocean_gen(size:Vector2,atlas_coords:Array,source_id:int,pos:Vector2=Vector2.ZERO):
	
	for x in range(pos.x-size.x/2,pos.x+size.x/2):
			for y in range(pos.y-size.y/2,pos.y+size.y/2):
				if randi_range(0,100)<20:
					tilemap_layer2.set_cell(Vector2(x,y),source_id,atlas_coords[0])
				else:
					tilemap_layer2.set_cell(Vector2(x,y),source_id,atlas_coords[1])
func room_gen(size :Vector2,atlas_coords:Array,source_id:int,terrain:bool=false,
pos:Vector2=Vector2.ZERO,padding:Vector2=Vector2.ZERO):
	var border:Vector2=size-padding
	var	tile_array:Array=[]
	if terrain:
		for x in range(pos.x-size.x/2,pos.x+size.x/2):
			for y in range(pos.y-size.y/2,pos.y+size.y/2):
				var vector:Vector2=Vector2(x,y)
				if vector.x<border.x and vector.y<border.y:
					tile_array.append(Vector2(x,y))
				
		tilemap_layer.set_cells_terrain_connect(tile_array,0,0)
	else:
		for x in range(pos.x-size.x/2,pos.x+size.x/2):
			for y in range(pos.y-size.y/2,pos.y+size.y/2):
				var vector:Vector2=Vector2(x,y)

				var atlas=atlas_coords.pick_random()
				tilemap_layer.set_cell(Vector2(x,y),source_id,atlas)
				
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
	pass
	#player_spawn_handler()
	
