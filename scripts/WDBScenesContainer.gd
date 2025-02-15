extends Node3D
var Root : Node
var LogWriter : Node
var wdb_dsr_path : String = "../wdb.dsr"

var scene_importer : WDB_FileLoader

func reload():
	Root = get_tree().get_root().get_child(0)
	LogWriter = Root.LogWriter
	
func getNameFromPath(string : String, withFormat : bool) -> String:
	var file_name : String = string.split("/")[-1]
	
	if !withFormat:
		var file_format : String = '.' + file_name.split(".")[-1]
		return file_name.left(len(file_name) - len(file_format))
	else:
		return file_name

var total_import_time : float
var total_init_time   : float
func ImportFile(scn_par : Node, file_path : String, hideAfterInit : bool, removeAfterInit : bool, disableAutoSpace : bool) -> void:
	var start_time : int = Time.get_ticks_msec()
	var wdb_file : FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var wdb_name : String = getNameFromPath(file_path, false)
	
	if (not FileAccess.file_exists(file_path)):
		var alertMsg : String = 'File "%s" is not exists!' % file_path
		LogSystem.writeToOutputLog(alertMsg)
		breakpoint
		return
	
	scene_importer = WDB_FileLoader.new()
	
	#получение размера файла
	wdb_file.seek_end(0)
	var file_size : int = wdb_file.get_position()
	wdb_file.seek(0)

	var wdb_buffer : StreamPeerBuffer = StreamPeerBuffer.new()
	wdb_buffer.set_data_array(wdb_file.get_buffer(file_size))
	wdb_file.close()
	
	var WDB_obj : WDBClass = WDBClass.new()
	
	if !file_size:
		LogWriter.writeErrorLogAndExit('Критическая ошибка при импорте файла "%s."' % [file_path], 'Файл пустой!\nFile is empty!', "viewer_error.log")
	else:
		var wdb_test : int = wdb_buffer.get_32()
		if (wdb_test != 541213783):
			LogWriter.writeErrorLogAndExit('Критическая ошибка при импорте файла "%s."' % [file_path], 'Указанный файл - не WDB!\nFile is not WDB!', "viewer_error.log")
		else:
			#DisplayServer.window_set_title('WDB Viewer :: importing "%s", please wait...' % wdb_name)
			call_deferred("add_child", WDB_obj)
			#self.add_child(WDB_obj)
			scene_importer.setActiveScene(WDB_obj)
			scene_importer.setActiveSceneName(wdb_name)
			
			WDB_obj.call_deferred("set_name", wdb_name)
			#WDB_obj.name = wdb_name
			WDB_obj.LoadFromFile(wdb_buffer, scene_importer)
			
			
			scn_par.current_action_name = "Loading scenes..."
			scn_par.loading_scene_name = wdb_name
			
			
			LogSystem.writeToErrorLog('*** %s ***' % wdb_name)
			
			#WDB_obj.get_node("Header").contents.reverse()
			
			#импорт данных из WDB
			#for record in WDB_obj.get_node("Header").contents:
			#	#переход к UnitGroup (403), в нём обычно лежат модели
			#	if record[0] == 403:     #type=ContainerUnitGroup
			#		wdb_buffer.seek(record[1]) #offset
			#		WDB_obj.add_child(scene_importer.read_WDBNode(wdb_buffer, scene_importer))
			#	#сначала переход к блоку данных, только затем импорт инфы о моделях
			#	if record[0] == 404:     #type=ContainerData
			#		wdb_buffer.seek(record[1]) #offset
			#		WDB_obj.add_child(scene_importer.read_WDBNode(wdb_buffer, scene_importer))
			#	#таблица смещений для объектов-привязок (RefToContainer)
			#	if record[0] == 407:     #type=ContainerRefTable1
			#		wdb_buffer.seek(record[1]) #offset
			#		WDB_obj.add_child(scene_importer.read_WDBNode(wdb_buffer, scene_importer))

	wdb_buffer.clear()
	
	if (WDB_obj):
		WDB_obj.hideAfterInit   = hideAfterInit
		WDB_obj.removeAfterInit = removeAfterInit
		WDB_obj.disableAutoSpace = disableAutoSpace
	
	var load_time : float = (Time.get_ticks_msec() - start_time) / 1000.0
	LogSystem.writeToOutputLog('"%s.wdb" %.3fs' % [wdb_name, load_time])
	#print('"%s" imported in %.3fs' % [file_path, load_time])
	total_import_time += load_time
	
var not_found_materials : Array
var not_found_references : Array
var unknown_material_par : Array
var unknown_material_par_mtl : Array
var unknown_material_typ : Array
var unknown_material_typ_mtl : Array

func InitializeScenes(scn_par: Node, hide_LOD : bool, debug_meshes : bool, init_caseRefSwitch : bool, debug_materials : bool) -> void:
	var wdb_res : Array #сцены с текстурами
	var wdb_mesh : Array #сцены с моделями
	var wdb_all : Array
	
	#зачем это? сначала надо инициализировать wdb с
	#материалами и текстурами, а файлы с 3d-моделями
	#в последнюю очередь
	var child_cnt : int = self.get_child_count()
	for child in self.get_children():
		#если нет UnitGroup, значит, файл с текстурами
		#перемещение такого объекта в самый верх иерархии
		if len(child.unit_nodes) == 0:
			wdb_res.append(child)
			#self.call_deferred('move_child', child, 0)
		else:
			wdb_mesh.append(child)
			
	#breakpoint
	
	wdb_all.append_array(wdb_res)
	wdb_all.append_array(wdb_mesh)

	var iter : int = 0
	#for child in self.get_children():
	for child in wdb_all:
		var start_time : float = Time.get_ticks_msec()
		
		child.initializeScene(hide_LOD, debug_meshes, init_caseRefSwitch, debug_materials)
		
		var load_time : float = (Time.get_ticks_msec() - start_time) / 1000.0
		LogSystem.writeToOutputLog('"%s" %.3fs' % [child.name, load_time])
		total_init_time += load_time
		
		iter += 1
		scn_par.get_parent().loading_scene_name = child.name
		scn_par.get_parent().current_action_name = "Initializing scenes..."
		scn_par.get_parent().init_value = (iter / scn_par.get_parent().scenes_count_flt)
	
	if (len(not_found_materials)):
		print('%d materials NOT FOUND, check viewer_error.log' % len(not_found_materials))
		LogSystem.writeToErrorLogNoPrint('\nFollowing materials NOT FOUND in all imported WDBs:')
		for mtl in not_found_materials:
			LogSystem.writeToErrorLogNoPrint('* "%s"' % mtl)
			
	if (len(not_found_references)):
		print('%d references NOT FOUND, check viewer_error.log' % len(not_found_references))
		LogSystem.writeToErrorLogNoPrint('\nFollowing references NOT FOUND in all imported WDBs:')
		for ref in not_found_references:
			LogSystem.writeToErrorLogNoPrint('* "%s"' % ref)
	
	if (len(unknown_material_typ)):
		LogSystem.writeToErrorLogNoPrint('\nUnknown material types:')
		for i in range(len(unknown_material_typ)):
			LogSystem.writeToErrorLogNoPrint('* "%s" -> "%s"' % [unknown_material_typ[i], unknown_material_typ_mtl[i]])
	
	if (len(unknown_material_par)):
		LogSystem.writeToErrorLogNoPrint('\nUnknown material params:')
		for i in range(len(unknown_material_par)):
			LogSystem.writeToErrorLogNoPrint('* "%s" -> "%s"' % [unknown_material_par[i], unknown_material_par_mtl[i]])

	#for child in self.get_children():
	for child in wdb_all:
		#child.afterInit()
		if (child.hideAfterInit):
			child.visible = false
		if (child.removeAfterInit):
			if (is_instance_valid(child)):
				child.queue_free()
			#child.queue_free()
	

	#var node_viewer : Node = self.get_children()[self.get_child_count() - 1].node_viewer
	#if (node_viewer):
	#	var viewer_space : Node = node_viewer.objectData.space.ref_obj
	#	if (viewer_space):
	#		get_parent().get_node("Viewer").set_global_position(viewer_space.get_global_position())
	
func OptimizeScenes() -> void:
	for child in self.get_children():
		#var start_time : float = Time.get_ticks_msec()
		
		#child.optimizeScene()
		
		#если нет NodeObject, значит, файл ресурсов
		if (is_instance_valid(child)):
			if not len(child.object_nodes):
				child.queue_free()
		
		#var load_time : float = (Time.get_ticks_msec() - start_time) / 1000.0
		#LogSystem.writeToOutputLog('"%s" %.3fs' % [child.name, load_time])
	
func printImportStats() -> void:
	LogSystem.writeToOutputLog('\nTotal import time: %.3fs' % [total_import_time])
	LogSystem.writeToOutputLog('Total init time: %.3fs' % [total_init_time])
	total_import_time = 0
	total_init_time   = 0
	
func placeViewerToPos(start_position : Vector3) -> void:
	get_parent().get_node("Viewer").set_global_position(start_position)
	
func placeViewerToNode(wdb_entrypoint : String) -> void:
	for wdb in self.get_children():
		for nodeViewer in wdb.viewer_nodes:
			if nodeViewer.objectData.object_name == wdb_entrypoint:
				var space : Node = nodeViewer.objectData.space.ref_obj
				if (space):
					get_parent().get_node("Viewer").set_global_position(space.get_global_position())
	
			#breakpoint
			#if nodeViewer
	
func searchMaterial(mtl_name : String) -> Object:
	#print(mtl_name)
	#var result : StandardMaterial3D
	
	for scn in self.get_children():
		for mtl in scn.material_nodes:
			if mtl.object_name == mtl_name:
				return mtl
	
	if (!not_found_materials.has(mtl_name)):
		not_found_materials.append(mtl_name)
	return null
	#if !result:
	#	result = StandardMaterial3D.new()
	#	
	#return result
		
