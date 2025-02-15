class_name WDB_VolumeTable extends WDB_DataContainer

#wdb.dsr description:
#( DWORD numRooms )
#( VolumeRoom rooms (( ITERATED numRooms ) ) )

var numRooms : int
var rooms    : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 954

	super(file, loader)
	self.name = "VolumeTable_%s" % self.offset_hex
	#self.name = WDB_ASCIIZ.ApplyName(self.object_name, "VolumeTable_%s" % self.offset_hex)
	
	numRooms = file.get_u32()
	for i in range(numRooms):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			rooms.append(child_obj)
			call_deferred("add_child", child_obj)
		
		#var room : WDB_VolumeRoom = WDB_VolumeRoom.new()
		#room.LoadFromBuffer(file, loader)
		#rooms.append(room)
