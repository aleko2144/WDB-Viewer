class_name WDB_VolumeRoom extends WDB_NodeContainer

#wdb.dsr description:
#( class VolumeRoom ( Container ) ("955") ()
#   (
#      ( ASCIIZ name )
#      ( DWORD flags )
#      ( Sphere sphere )
#      ( DWORD numDoors )
#      ( VolumeDoor doors ( ( ITERATED numDoors ) ) )
#   )
#   ()
#)

var room_name : String
var flags     : int
var sphere    : WDB_Sphere
var numDoors  : int
var doors     : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "VolumeRoom_%s" % self.offset_hex
	tag = 955
	
	room_name = WDB_ASCIIZ.LoadFromBuffer(file)
	flags     = file.get_u32()
	sphere    = WDB_Sphere.new()
	sphere.LoadFromBuffer(file)
	numDoors  = file.get_u32()
	for i in range(numDoors):
		var door : Node = loader.read_WDBNode(file, loader)
		if (door):
			doors.append(door)
			self.add_child(door)
		
	#while (file.get_position() < data_end_offset):
	#	var child_obj : Node = loader.read_WDBNode(file, loader)
	#	if (child_obj): #чтобы не было ошибок при импорте
	#		self.add_child(child_obj)
