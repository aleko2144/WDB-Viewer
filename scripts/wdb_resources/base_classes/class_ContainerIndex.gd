class_name WDB_ContainerIndex extends WDB_DataContainer

#wdb.dsr class description:
#( DWORD index_flags ( ( MNEMONICS "it*" ) ) )
#( DWORD num )
#( Index indices ( PARAMETRIZED ( ITERATED num ) ) )

var index_flags : int #похоже, что этот параметр не влияет
var num_index   : int
var index_data  : PackedInt32Array
#var index_data  : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	index_flags = file.get_32()
	num_index   = file.get_32()
	for i in range(num_index):
		index_data.append(file.get_u16())
