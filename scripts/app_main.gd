extends Node3D
var LogWriter : Node
var LoaderUtils : Node
var Viewer : Node
var WDBScenes : Node

var str_AppVersion : String = "v 0.11 28.01.25" #"v 0.1 17.02.24"
var str_RootDir : String = "."

@export var config_file_path : String = "viewer.ini"
var config_file : ConfigFile = ConfigFile.new()
#параметры скриншотов
var screenshots_path    : String
var screenshots_format  : String
var screenshots_quality : float

var scenes_file_path : String
var scenes_load_list : Array
var scenes_count_flt : float
var hide_LOD         : bool
var debug_meshes     : bool
var init_caseRef     : bool
var debug_materials  : bool
var import_only_meshes : bool
var remove_res_scenes : bool

var wdb_entrypoint   : String
var viewer_start_pos : Vector3

func str2vec3(string : String) -> Vector3:
	var result : Vector3
	var splitResult : Array = string.split(" ", false, 3)
	if (len(splitResult) == 3):
		result.x = -float(splitResult[0])
		result.y = float(splitResult[2])
		result.z = float(splitResult[1])
	#else:
		#print('ERROR: str2vec3(%s): splitResult != 3' % string)
		#OS.alert('ERROR: str2vec3(%s): splitResult != 3' % string, 'Fatal error')
		#get_tree().quit()
		
	return result

var target_win_res : Vector2i
func prepareWindow() -> void:
	#var win_res : Vector2i = Vector2i(xres, yres) #DisplayServer.window_get_size()
	var screen_size = DisplayServer.screen_get_size()
	
	var win_x : int = (screen_size.x/2) - (target_win_res.x/2)
	var win_y : int = (screen_size.y/2) - (target_win_res.y/2)

	get_window().set_size(target_win_res)
	get_window().set_position(Vector2i(win_x, win_y))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	var loading_window : Window = get_node("Viewer/window_LoadingBar")
	win_x = (target_win_res.x/2) - (loading_window.size.x/2)
	win_y = (target_win_res.y/2) - (loading_window.size.y/2)
	loading_window.set_position(Vector2i(win_x, win_y))
	
	var loading_background : Control = get_node("Viewer/loadingBackground")
	loading_background.size = target_win_res
	#win_x = -(target_win_res.x/2)
	#win_y = -(target_win_res.y/2)
	#loading_background.set_position(Vector2i(win_x, win_y))
	
var loading_value : float
var init_value    : float
var current_action_name : String
var loading_scene_name  : String

var thread : Thread

func _ready():
	LogWriter = $LogWriter
	LoaderUtils = $LoaderUtils
	Viewer = $Viewer
	#Scenes = $Scenes
	
	$LogWriter.reload()
	$WDBScenes.reload()
	
	var err = config_file.load(config_file_path)
	
	if err != OK:
		var alertMsg : String = 'Config file "%s" not found! Starting aborted.' % [config_file_path]
		OS.alert(alertMsg, 'Critical error')
		LogSystem.writeToOutputLog(alertMsg)
		get_tree().quit()
		return
		
	#render settings
	#var win_res : Vector2i
	target_win_res.x = config_file.get_value("render", "xres", 1024)
	target_win_res.y = config_file.get_value("render", "yres", 768)
	prepareWindow()
	
	screenshots_path    = config_file.get_value("screenshots", "path", "./screenshots")
	screenshots_format  = config_file.get_value("screenshots", "format", "png")
	screenshots_quality = float(config_file.get_value("screenshots", "quality", "0.9"))
	hide_LOD            = bool(config_file.get_value("common", "hide_LOD", 0))
	debug_meshes        = bool(config_file.get_value("common", "debug_meshes", 0))
	init_caseRef        = bool(config_file.get_value("common", "init_caseRefSwitch", 0))
	debug_materials     = bool(config_file.get_value("common", "debug_materials", 0))
	import_only_meshes  = bool(config_file.get_value("common", "import_only_meshes", 0))
	remove_res_scenes   = bool(config_file.get_value("common", "remove_res_scenes", 0))
	scenes_file_path = config_file.get_value("common", "scenes_file", "scenes.lst")

	if (!bool(config_file.get_value("common", "light_shadows", 0))):
		$DirectionalLight3D.shadow_enabled = false
		$DirectionalLight3D.light_energy = 0.3
	else:
		$DirectionalLight3D.shadow_enabled = true
		$DirectionalLight3D.light_energy = 0.125
	
	#wdb_entrypoint   = config_file.get_value("common", "entrypoint", "")
	#viewer_start_pos = str2vec3(config_file.get_value("common", "start_position", "0;0;0"))
	
	#удаление старых *.log-файлов
	DirAccess.remove_absolute('viewer_output.log')
	DirAccess.remove_absolute('viewer_error.log')
	LogSystem.writeOutputLogHeader()
	LogSystem.writeErrorLogHeader()
	
	make_scenes_list(scenes_file_path)
	
	scenes_count_flt = len(scenes_load_list)
	
	#thread = Thread.new()
	#thread.start(import_all_scenes.bind($WDBScenes), Thread.PRIORITY_NORMAL)
	#thread.start(import_all_scenes)
	
	#showLoadingBar()
	
	#var loading_window : Window = get_node("Viewer/window_LoadingBar")
	#var loading_bar : ProgressBar = get_node("Viewer/window_LoadingBar/ProgressBar")
	#var current_file : Label = get_node("Viewer/window_LoadingBar/FileLabel")
	#var loading_background : TextureRect = get_node("Viewer/loadingBackground")
	#var loading_texture : GradientTexture2D = loading_background.texture
	
	#thread = Thread.new()
	#thread.start(drawLoadingBar.bind(self, loading_window, loading_bar, current_file, loading_background, loading_texture), Thread.PRIORITY_LOW)
	#thread.set_thread_safety_checks_enabled(false)
	
	import_all_scenes()

func _exit_tree() -> void:
	thread.wait_to_finish()

func read_all_WDB() -> void:
	var iter : int = 0
	for scn in scenes_load_list:
		$WDBScenes.ImportFile(self, scn[0], scn[1], scn[2], scn[3])
		iter += 1
		loading_value = (iter / scenes_count_flt)

	scenes_load_list.clear()
	
func init_all_WDB() -> void:
	LogSystem.writeToOutputLog('\n-Init:------------------------------------------------')
	$WDBScenes.InitializeScenes(self, hide_LOD, debug_meshes, init_caseRef, debug_materials)
	$WDBScenes.printImportStats() 

func import_all_scenes() -> void:
	#thread.set_thread_safety_checks_enabled(false)
	
	LogSystem.writeToOutputLog('-Imports:----------------------------------------------')
	#LogSystem.writeToOutputLog('------------------------------------------------------')
	
	read_all_WDB()
	init_all_WDB()
	
	#hideLoadingBar()
	
	if (!viewer_start_pos.is_equal_approx(Vector3(0, 0, 0))):
		$WDBScenes.placeViewerToPos(viewer_start_pos)
	elif (wdb_entrypoint):
		$WDBScenes.placeViewerToNode(wdb_entrypoint)
		
	#if (remove_res_scenes):
	#	WDBScenes.OptimizeScenes()
		
	#if (import_only_meshes):
	#	LogSystem.writeToOutputLog('\n-Optimization:----------------------------------------')
	#	WDBScenes.OptimizeScenes()
	
	#DisplayServer.window_set_title('WDB Viewer')

func make_scenes_list(scn_file_name : String) -> void:
	var loading_scene_name : String
	var loading_scene_hide : bool

	var scenes_file : FileAccess = FileAccess.open(scn_file_name, FileAccess.READ)
		
	if (!scenes_file):
		var alertMsg : String = 'Defined list file "%s" not found!' % [scn_file_name]
		#OS.alert(alertMsg, 'Critical error')
		LogSystem.writeToOutputLog(alertMsg)
		#get_tree().quit()
		return
		
	var scene_line : String
	var scenes_file_len : int = scenes_file.get_length()
	var temp_str : PackedStringArray
	var temp_par_str : PackedStringArray
	var flag_hideAfterInit : bool
	var flag_removeAfterInit : bool
	var flag_disableAutoSpace : bool
	
	while (scenes_file.get_position() < scenes_file_len):
		scene_line = scenes_file.get_line().dedent()
		#проверка, 1) пустая ли строка,
		#          2) является ли она комментарием,
		#          3) и есть ли в начале "[scene:"
		if (scene_line.is_empty() or scene_line[0] == ";"):
			continue
		
		temp_str = scene_line.split("->", false) 
		temp_par_str = scene_line.split(":", false) 
		#print(temp_str)
		
		
		if (len(temp_par_str) > 1):
			#breakpoint
			if (temp_par_str[0] == "hideAfterInit"):
				if (temp_par_str[1].dedent() == "true"):
					flag_hideAfterInit = true
				else:
					flag_hideAfterInit = false
		
			elif (temp_par_str[0] == "removeAfterInit"):
				if (temp_par_str[1].dedent() == "true"):
					flag_removeAfterInit = true
				else:
					flag_removeAfterInit = false
					
			elif (temp_par_str[0] == "disableAutoSpace"):
				if (temp_par_str[1].dedent() == "true"):
					flag_disableAutoSpace = true
				else:
					flag_disableAutoSpace = false
			
			elif (temp_par_str[0] == "startposition"):
				var temp_str2 : String = temp_par_str[1].dedent().split(";")[0]
				viewer_start_pos = str2vec3(temp_str2)
				#print(temp_str2)
				#print(viewer_start_pos)
			
			elif (temp_par_str[0] == "entrypoint"):
				var temp_str2 : String = temp_par_str[1].dedent().split(";")[0]
				wdb_entrypoint = temp_str2
			
		if (len(temp_str) > 1):
			loading_scene_name = temp_str[1].strip_edges() #.dedent()
			#[0] - scene, [1] - path
				
			if (temp_str[0] == "scene"):
				#if (len(temp_str) > 2): #есть ли параметр hide
				#	loading_scene_hide = true
				#else:
				#	loading_scene_hide = false
				
				#$SceneImporter.ImportScene(loading_scene_name, loading_scene_hide)
				scenes_load_list.append([loading_scene_name, flag_hideAfterInit, flag_removeAfterInit, flag_disableAutoSpace])
				
			elif (temp_str[0] == "dir"):
				#loadFromDir(loading_scene_name)
				var modules_list : Array = LoaderUtils.getFilesFromDir(loading_scene_name, "wdb")
				for module in modules_list:
					#$SceneImporter.ImportScene(module, false)
					scenes_load_list.append([module, flag_hideAfterInit, flag_removeAfterInit, flag_disableAutoSpace])
					
			#подгрузка ещё одного списка
			elif (temp_str[0] == "include"):
				#breakpoint
				make_scenes_list(loading_scene_name)
				#print(loading_scene_name)
	
	scenes_file.close()

func make_screenshot():
	#https://github.com/godotengine/godot-demo-projects/blob/master/viewport/screen_capture/screen_capture.gd
	
	var dir_access : DirAccess = DirAccess.open(".")
	var path_check : bool = dir_access.dir_exists(screenshots_path)
	var screenshot_name : String
	
	if (!path_check):
		dir_access.make_dir(screenshots_path)
	
	var screenshot_count : int = 1 + LoaderUtils.getFilesCountInDir(screenshots_path, "")
	
	var image : Image = get_viewport().get_texture().get_image()
	#var image_tex : ImageTexture = ImageTexture.create_from_image(image)

	if (screenshot_count <= 9):
		screenshot_name = "%s/photo00%d.%s" % [screenshots_path, screenshot_count, screenshots_format]
	elif (screenshot_count >= 10 and screenshot_count <= 99):
		screenshot_name = "%s/photo0%d.%s" % [screenshots_path, screenshot_count, screenshots_format]
	else:
		screenshot_name = "%s/photo%d.%s" % [screenshots_path, screenshot_count, screenshots_format]
	
	match screenshots_format:
		"png":
			image.save_png(screenshot_name)
		"jpg":
			image.save_jpg(screenshot_name, screenshots_quality)
	
var wireframe : bool
var unshaded : bool
var background_mode : int #0 - b3d, 1 - custom color, 2 - sky

func updateBackground() -> void:
	var WorldEnv : WorldEnvironment = $WorldEnvironment
	match background_mode:
		1:
			WorldEnv.environment.background_mode = Environment.BG_COLOR
			WorldEnv.environment.background_color = Color("808080")
			WorldEnv.environment.ambient_light_color = Color("FFFFFF")
			$Viewer/ViewerGUI/Label_BackgroundMode.text = "background=color"
			$DirectionalLight3D.visible = false
		0:
			WorldEnv.environment.background_mode = Environment.BG_SKY
			var sky : Sky = Sky.new()
			var sky_mtl : ProceduralSkyMaterial = ProceduralSkyMaterial.new()
			#sky_mtl.sky_energy_multiplier = 5
			sky.sky_material = sky_mtl
			WorldEnv.environment.background_sky = sky
			$Viewer/ViewerGUI/Label_BackgroundMode.text = "background=sky"
			$DirectionalLight3D.visible = false

#отрисовка сетки
func _init():
	RenderingServer.set_debug_generate_wireframes(true)

var draw_loading_bar : bool = true

func hideLoadingBar() -> void:
	
	var loading_window : Window = get_node("Viewer/window_LoadingBar")
	var loading_background : TextureRect = get_node("Viewer/loadingBackground")
	
	draw_loading_bar = false
		
	get_node("Viewer").lock_input = false
	get_node("Viewer/ViewerGUI").hide()
		
	loading_window.hide()
	loading_background.hide()

func showLoadingBar() -> void:
	var loading_window : Window = get_node("Viewer/window_LoadingBar")
	var loading_background : TextureRect = get_node("Viewer/loadingBackground")
	
	draw_loading_bar = true
		
	get_node("Viewer").lock_input = true
	get_node("Viewer/ViewerGUI").visible = false
		
	loading_window.visible = true
	loading_background.visible = true

func drawLoadingBar(mainObj : Node, loading_window : Window, loading_bar : ProgressBar, current_file : Label, loading_background : TextureRect, loading_texture : GradientTexture2D) -> void:
	#var loading_window : Window = mainObj.get_node("Viewer/window_LoadingBar")
	#var loading_bar : ProgressBar = get_node("Viewer/window_LoadingBar/ProgressBar")
	#var current_file : Label = get_node("Viewer/window_LoadingBar/FileLabel")
	#var loading_background : TextureRect = get_node("Viewer/loadingBackground")
	#var loading_texture : GradientTexture2D = loading_background.texture
		
	while (draw_loading_bar == true):
		#print(mainObj.current_action_name)
		loading_window.title = mainObj.current_action_name
		loading_bar.value = (50.0 * (loading_value)) + (50.0 * init_value)
		#current_file.text = loading_scene_name
	
		#loading_texture.gradient.offsets[1] = 0.2 + (0.6 * (loading_bar.value / 100.0))
	
		#loading_window.title = current_action_name
		#loading_bar.value = (50.0 * (loading_value)) + (50.0 * init_value)
		#current_file.text = loading_scene_name
	
		#loading_texture.gradient.offsets[1] = 0.2 + (0.6 * (loading_bar.value / 100.0))
	
	#if (loading_bar.value == 100.0):
	#	draw_loading_bar = false
		
	#	get_node("Viewer").lock_input = false
	#	get_node("Viewer/ViewerGUI").visible = true
		
	#	loading_window.visible = false
	#	loading_background.visible = false
		
	#	#loading_window.queue_free()
	#	#loading_background.queue_free()

func _process(_delta: float) -> void:
	#if (draw_loading_bar == true):
	#	drawLoadingBar()

	#var loading_bar : ProgressBar = get_node("Viewer/LoadingProgressBar")
	#loading_value = $WDBScenes.get_child_count() / scenes_total_cnt
	#loading_bar.value = 80.0 * (loading_value)
	
	#print($WDBScenes.get_child_count() / scenes_count_flt)
	#print($WDBScenes.get_child_count())
	#print(scenes_total_cnt)
	
	#print(loading_value)
	#print(init_value)
	
	if (Input.is_action_just_pressed("ui_screenshot")):
		make_screenshot()
	
	if (Input.is_action_just_pressed("render_wireframe")):
		wireframe = !wireframe
		if (wireframe):
			get_viewport().set_debug_draw(SubViewport.DEBUG_DRAW_WIREFRAME)
			$Viewer/ViewerGUI/Label_DrawMode.text = "DrawMode=wireframe"
		else:
			get_viewport().set_debug_draw(SubViewport.DEBUG_DRAW_DISABLED)
			$Viewer/ViewerGUI/Label_DrawMode.text = "DrawMode=normal"
	
	if (Input.is_action_just_pressed("render_unshaded")):
		unshaded = !unshaded
		if (unshaded):
			get_viewport().set_debug_draw(SubViewport.DEBUG_DRAW_UNSHADED)
			$Viewer/ViewerGUI/Label_DrawMode.text = "DrawMode=unshaded"
		else:
			get_viewport().set_debug_draw(SubViewport.DEBUG_DRAW_DISABLED)
			$Viewer/ViewerGUI/Label_DrawMode.text = "DrawMode=normal"
			
	if (Input.is_action_just_pressed("render_change_background")):
		if background_mode < 2:
			background_mode += 1
		else:
			background_mode = 0
			
		updateBackground()
	
	if (Input.is_action_just_pressed("render_switch_light")):
		$DirectionalLight3D.visible = !$DirectionalLight3D.visible
