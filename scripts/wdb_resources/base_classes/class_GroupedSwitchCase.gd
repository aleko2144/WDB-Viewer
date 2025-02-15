class_name WDB_GroupedSwitchCase

#wdb.dsr:
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
	ref = loader.read_WDBNode(file, loader)
	
	space_num = file.get_32()
	for i in range(space_num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		#if (child_obj): #чтобы не было ошибок при импорте
		#	get_parent().add_child(child_obj
		spaces.append(child_obj)
		
	index_num = file.get_32()
	for i in range(index_num):
		mask.append(file.get_u8())
