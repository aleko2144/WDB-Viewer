class_name WDB_NodeCaseRefMaskDData extends WDB_SimpleNodeData

#( Ref ref )
#( DWORD space_num )	
#( Ref	spaces ( (ITERATED space_num ) ) )
#( DWORD index_num )	
#( BYTE mask ( (ITERATED index_num ) ) )

var ref       : Node
var space_num : int
var spaces    : Array
var index_num : int
var mask      : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	ref = loader.read_WDBNode(file, loader)
	
	space_num = file.get_32()
	for i in range(space_num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		spaces.append(child_obj)
		
	index_num = file.get_32()
	for i in range(index_num):
		mask.append(file.get_u8())