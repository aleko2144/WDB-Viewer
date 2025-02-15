extends Node3D

var position2D : Vector2

var lock_input : bool = true
@onready var light_node : Node = self.get_node("SpotLight3D")
var light_enabled : bool

@onready var gui_node : Node = self.get_node("ViewerGUI")
var gui_visible : bool
	
func prepare_FileDialog():
	#for scene in ScenesNode.get_children():
	#importing_scene_root.exportAsGLTF('h:/d2/Dev/Viewer_2023/test_export/')
	#$dialog_File.position.x = (get_viewport().get_window().size.x - $FileDialog.size.x) / 2
	#$dialog_File.position.y = (get_viewport().get_window().size.y - $FileDialog.size.y) / 2
	##$FileDialog.current_path = 'h:/d2/Dev/Viewer_2023/test_export/'
	
	$dialog_File.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	$dialog_File.title = "Select a folder to save *.gltf"
	
	$dialog_File.show()

func _process(_delta):
	if (lock_input):
		return
	
	position2D.x = self.position.x
	position2D.y = self.position.z
		
	if (Input.is_action_just_pressed('viewer_light')):
		light_enabled = not light_enabled
		light_node.set_visible(light_enabled)
		
	if (Input.is_action_just_pressed('viewer_hide_ui')):
		gui_visible = not gui_visible
		gui_node.set_visible(gui_visible)
		
	if (Input.is_action_just_pressed("viewer_export_scene")):
		prepare_FileDialog() #для экспорта
		
	if (Input.is_action_just_pressed("viewer_open_struct_view")):
		$window_WDBScenes.showStructWindow()


func _on_dialog_file_dir_selected(dir: String) -> void:
	var export_path : String = dir + '/'
	#print(export_path)
	for scene in get_parent().get_node("WDBScenes").get_children():
		scene.exportAsGLTF(export_path)
		#scene.exportAsObj(export_path)
