class_name WDB_NodePumpRoomData extends WDB_SimpleNodeData

#wdb.dsr:
#( DWORD num )
#( Ref pu_refs   ( (ITERATED num ) ) )

var num : int
var pu_refs : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	num = file.get_32()

	for i in range(num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			pu_refs.append(child_obj)
