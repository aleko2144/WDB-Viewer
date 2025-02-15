class_name WDB_ContainerVIPMLOD extends WDB_DataContainer

#wdb.dsr description:
#( ContainerErrorMetrics errorMetrics )
#( DWORD num )
#( VIPMStruct structs ( ( ITERATED num ) ) )
#( ContainerIndexDynamic indices )

var errorMetrics : Node
var num_structs  : int
var structs      : Array
var indices      : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 314
	
	super(file, loader)
	self.name = "VIPMLOD_%s" % self.offset_hex
	
	errorMetrics = loader.read_WDBNode(file, loader)
	num_structs  = file.get_32()
	
	for i in range(num_structs):
		var struct = WDB_VIPMStruct.new()
		struct.LoadFromBuffer(file)
		structs.append(struct)
	
	indices      = loader.read_WDBNode(file, loader)
	
	#а нужно ли добавлять их в сцену, если они и так есть в скрипте объекта?
	if (errorMetrics): #чтобы не было ошибок при импорте
		call_deferred("add_child", errorMetrics)
	if (indices):      #чтобы не было ошибок при импорте
		call_deferred("add_child", indices)
