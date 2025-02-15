class_name WDB_NodeLoadCaseRefData extends WDB_SimpleNodeData 

#wdb.dsr:
#( DWORD num_ref )
#( Ref refs ( (ITERATED num_ref) ) )
#( Ref ref )

var num_ref : int
var refs    : Array
var ref     : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	num_ref = file.get_32()
	
	for i in range(num_ref):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			refs.append(child_obj)
	
	ref = loader.read_WDBNode(file, loader)
