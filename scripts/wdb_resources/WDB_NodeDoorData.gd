class_name WDB_NodeDoorData extends WDB_SimpleNodeData

#wdb.dsr:
#( Ref pump_unit )
#( Ref room )
#( DWORD	num )
#( Vector  vertex ( (ITERATED num) ) )

var pump_unit : Node
var room : Node
var num : int
var vertex : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	pump_unit = loader.read_WDBNode(file, loader)
	room      = loader.read_WDBNode(file, loader)
	
	num       = file.get_32()
	for i in range(num):
		vertex.append(VectorUtils.LoadDVec3FromBuffer(file))
		#vertex.append(Vector3(file.get_float(), file.get_float(), file.get_float()))

	#for i in range(num):
	#	var child_obj : Node = loader.read_WDBNode(file, loader)
	#	if (child_obj): #чтобы не было ошибок при импорте
	#		pu_refs.append(child_obj)
