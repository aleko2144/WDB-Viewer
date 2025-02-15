class_name WDB_NodeLight extends WDB_NodeContainer

#var objectData: WDB_NodeLightData

#func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
#	#импорт данных
#	file.seek(file.get_position() + 8) #skip tag (1) and size
#	objectData = WDB_NodeLightData.new()
#	objectData.LoadFromBuffer(file, loader)
