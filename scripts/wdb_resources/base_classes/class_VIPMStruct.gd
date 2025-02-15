class_name WDB_VIPMStruct

#wdb.dsr:
#( WORD vsplitVert )
#( BYTE numNewTriangles )
#( BYTE numFixFaces )
#( DWORD fixFacesIndex )
#( float error )

var vsplitVert      : int
var numNewTriangles : int
var numFixFaces     : int
var fixFacesIndex   : int
var error           : float

func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	vsplitVert      = file.get_u16()
	numNewTriangles = file.get_u8()
	numFixFaces     = file.get_u8()
	fixFacesIndex   = file.get_u32()
	error           = file.get_float()
