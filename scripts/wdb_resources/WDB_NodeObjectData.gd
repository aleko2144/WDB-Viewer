class_name WDB_NodeObjectData extends WDB_SimpleNodeData

#wdb.dsr description:
#( DWORD objectType ( ( MNEMONICS "obj*" ) ) )
#( DWORD _objectFlag  ( ( MNEMONICS "objFlag*" ) ))
#( DWORD NumOfEntries )
#( Ref entry   ( (ITERATED NumOfEntries ) ) )

var objectType   : int #3 - VIPM, 
var objectFlag  : int 
var NumOfEntries : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	#print("%x" % file.get_position())
		
	super(file, loader)
	objectType   = file.get_32()
	objectFlag   = file.get_32()
	NumOfEntries = file.get_32()
