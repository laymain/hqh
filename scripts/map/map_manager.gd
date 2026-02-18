class_name MapManager extends Node

@export var cell_size : Vector3
@export var mesh_library : MeshLibrary
@export var player : Player

@onready var meshes : Dictionary[String, Array] = init_meshes()
var _grids: Array[GridMap] = []

func _ready() -> void:
    var content := load_map()
    create_map(content)

func load_map() -> Dictionary:
    var file := FileAccess.open("res://data/maps/test.json", FileAccess.READ)
    var content = null
    if file:
        content = file.get_as_text()
        file.close()
    assert(content != null, "ERROR: Could not read map.");
    return JSON.parse_string(content)

func create_map(content: Dictionary) -> void:
    clear()
    var size : Dictionary = content["size"]
    var width : int = size["width"]
    var height : int = size["height"]
    var layers := content["layers"] as Array
    _grids.clear()
    for i in layers.size():
        var grid := GridMap.new()
        grid.cell_size = cell_size
        grid.mesh_library = mesh_library
        grid.cell_center_x = false
        grid.cell_center_y = false
        grid.cell_center_z = false
        _grids.push_front(grid)
    for x in width:
        for y in height:
            for layer in layers.size():
                set_cell(x, y, layers[layer], _grids[layer])
    for grid in _grids:
        add_child(grid)

    _setup_dungeon_lighting()
    _setup_room_tints(content.lights as Array)
    _setup_markers(content.markers)

func init_meshes() -> Dictionary[String, Array]:
    return {
        "W": [mesh_library.find_item_by_name("template-wall")],
        "F": [mesh_library.find_item_by_name("template-floor"), mesh_library.find_item_by_name("template-floor-detail")],
        "C": [mesh_library.find_item_by_name("template-corner")],
        "R": [mesh_library.find_item_by_name("corridor")],
        "G": [mesh_library.find_item_by_name("gate")]
    }

func set_cell(x: int, y: int, data: Variant, grid: GridMap):
    var cell := read_cell(data[y][x])
    if cell != null:
        grid.set_cell_item(Vector3i(x, 0, y), cell.id, cell.orientation)

class Cell:
    var id: int
    var orientation: int
    func _init(p_id: int, p_orientation: int):
        id = p_id
        orientation = p_orientation

const ORIENTATIONS: Dictionary[String, int] = {
    "0": 10,  # 180°
    "1": 16,  # 90°
    "2": 0,   # 0°
    "3": 22,  # 270°
}

func read_cell(data: String) -> Cell:
    if data.length() == 2 and meshes.has(data[0]):
        return Cell.new(pick_variant(meshes[data[0]]), ORIENTATIONS[data[1]])
    return null

func pick_variant(variants: Array, detail_chance: float = 0.15) -> int:
    if variants.size() == 1 or randf() > detail_chance:
        return variants[0]
    return variants[randi_range(1, variants.size() - 1)]  # Detail variant

const TILE_SIZE := 4.0
const CELL_SIZE := Vector3(TILE_SIZE, TILE_SIZE, TILE_SIZE)

func _setup_dungeon_lighting() -> void:
    var dir_light := DirectionalLight3D.new()
    dir_light.rotation_degrees = Vector3(-35, -45, 0)
    dir_light.light_color = Color.html("#ffeedd")
    dir_light.light_energy = 0.4
    dir_light.shadow_enabled = true
    dir_light.shadow_blur = 2.0
    dir_light.shadow_opacity = 0.5
    add_child(dir_light)

func _setup_room_tints(lights_data: Array) -> void:
    for light_entry in lights_data:
        var x = light_entry[0]
        var y = light_entry[1]
        var color = light_entry[2]
        var intensity = light_entry[3]
        var radius = light_entry[4]
        
        var light := OmniLight3D.new()
        light.position = Vector3(x * TILE_SIZE, 2.0, y * TILE_SIZE)
        light.light_color = Color.html(color)
        light.light_energy = intensity
        light.omni_range = radius * TILE_SIZE
        light.omni_attenuation = 0.5
        light.shadow_enabled = false
        add_child(light)

func _setup_markers(markers: Array):
    for marker in markers:
        if marker.type == "START":
            player.global_position = _marker_to_world_position(marker)

func _marker_to_world_position(marker: Variant) -> Vector3:
    return Vector3(float(marker.x) * CELL_SIZE.x, CELL_SIZE.y + player.global_position.y, float(marker.y) * CELL_SIZE.z * 1.5)

func clear():
    for child in get_children():
        remove_child(child)
        child.queue_free()
