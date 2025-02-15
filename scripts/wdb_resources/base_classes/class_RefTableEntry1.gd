class_name RefTableEntry1

#wdb.dsr:
#( FileOffset entityOffset )
#( FileOffset nameOffset )
#( DWORD containerID )

var entityOffset : int
var nameOffset   : int
var containerID  : int

var ref_object   : Object

static func LoadFromBuffer(file : StreamPeerBuffer) -> RefTableEntry1:
	var entry : RefTableEntry1 = RefTableEntry1.new()
	
	entry.entityOffset = file.get_32()
	entry.nameOffset = file.get_32()
	entry.containerID = file.get_32()
	
	return entry
