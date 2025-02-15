class_name RefTableEntry

#wdb.dsr:
#( FileOffset entityOffset )
#( FileOffset nameOffset )

var entityOffset : int
var nameOffset   : int

var ref_object   : Object

static func LoadFromBuffer(file : StreamPeerBuffer) -> RefTableEntry:
	var entry : RefTableEntry = RefTableEntry.new()
	
	entry.entityOffset = file.get_32()
	entry.nameOffset = file.get_32()
	
	return entry
