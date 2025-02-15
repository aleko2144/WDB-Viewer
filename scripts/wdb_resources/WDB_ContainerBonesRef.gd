class_name WDB_ContainerBonesRef extends WDB_DataContainer

#wdb.dsr:
#( DWORD num )
#( Ref space  ( ( ITERATED num )))

var num   : int
var space : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 329

	super(file, loader)
	
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "BonesRef_%s" % self.offset_hex)
	
	num = file.get_32()
	for i in range(num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			space.append(child_obj)
