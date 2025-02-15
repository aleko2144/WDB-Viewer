class_name WDB_VolumeDoor extends WDB_NodeContainer

#wdb.dsr description:
#( class VolumeDoor ( Container ) ("956") ()
#   (
#      ( ASCIIZ name )
#      ( DWORD flags )
#      ( DWORD peerIndex )       ; index of the peer in this file, if any
#      ( DWORD peerDoorIndex )   ; index of the peering door in the peer in this file, if any
#      ( Ref peer )          ; refernce to the peer
#      ;; ( Plane plane )        ; can't pre-calculate neighbours for the sake of robustbess
#      ( DWORD numCorners )
#      ( Vector corners ((ITERATED numCorners)))
#   )
#   ()
#)

var door_name     : String
var flags         : int
var peerIndex     : int
var peerDoorIndex : int
var peer          : Node
var numCorners    : int
var corners       : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "VolumeDoor_%s" % self.offset_hex
	tag = 956
	
	door_name     = WDB_ASCIIZ.LoadFromBuffer(file)
	flags         = file.get_u32()
	peerIndex     = file.get_u32()
	peerDoorIndex = file.get_u32()
	peer          = loader.read_WDBNode(file, loader)
	numCorners    = file.get_u32()
	for i in range(numCorners):
		corners.append(VectorUtils.LoadDVec3FromBuffer(file))
		
	#while (file.get_position() < data_end_offset):
	#	var child_obj : Node = loader.read_WDBNode(file, loader)
	#	if (child_obj): #чтобы не было ошибок при импорте
	#		call_deferred("add_child", child_obj)
