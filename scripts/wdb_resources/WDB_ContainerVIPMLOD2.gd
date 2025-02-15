class_name WDB_ContainerVIPMLOD2 extends WDB_DataContainer

#wdb.dsr description:
#( ContainerErrorMetrics errorMetrics )
#( DWORD startIndex )
#( DWORD num )
#( VIPM2Struct structs ( ( ITERATED num ) ) )
#( ContainerVIPM2Operation  fixFace )

var errorMetrics : Node
var startIndex   : int
var num_structs  : int
var structs      : Array
var fixFace      : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 340
	
	super(file, loader)
	self.name = "VIPMLOD2_%s" % self.offset_hex
	
	errorMetrics = loader.read_WDBNode(file, loader) #дописать импорт всех errorMetrics
	startIndex   = file.get_32()
	num_structs  = file.get_32()
	
	for i in range(num_structs):
		var struct = WDB_VIPM2Struct.new()
		struct.LoadFromBuffer(file)
		structs.append(struct)
	
	fixFace      = loader.read_WDBNode(file, loader)
	
	#а нужно ли добавлять их в сцену, если они и так есть в скрипте объекта?
	if (errorMetrics): #чтобы не было ошибок при импорте
		call_deferred("add_child", errorMetrics)
	if (fixFace): #чтобы не было ошибок при импорте
		call_deferred("add_child", fixFace)
