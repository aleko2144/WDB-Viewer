class_name WDB_ContainerRefTable extends WDB_DataContainer

#wdb.dsr:
#( DWORD numOfRecords )
#( DWORD sizeOfRecord )
#( RefTableEntry entry ( ( ITERATED numOfRecords ) ) )
#( RefTableNamesEntry names ( ( ITERATED numOfRecords ) ) )

var numOfRecords : int
var sizeOfRecord : int
var entry        : Array
var names        : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 405
	
	super(file, loader)
	self.name = "RefTable_%s" % self.offset_hex
	
	numOfRecords = file.get_32()
	sizeOfRecord = file.get_32()
	
	for i in range(numOfRecords):
		entry.append(RefTableEntry.LoadFromBuffer(file))
	for i in range(numOfRecords):
		names.append(WDB_ASCIIZ.LoadFromBuffer(file))
