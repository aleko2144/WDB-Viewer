class_name WDB_MaterialParamStruct

#wdb.dsr:
#( DWORD nText )
#( ASCIIZ	paramName )
#( DWORD paramValue )

var nText      : int
var paramName  : String
var paramValue : PackedByteArray
#var paramValue : int
#var parValueFt : float #int
#var parValueIt : int

func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	nText      = file.get_32()
	paramName  = WDB_ASCIIZ.LoadFromBuffer(file)
	paramValue = file.get_data(4)[1]
	#parValueFt = file.get_float()
	#file.seek(file.get_position() - 4)
	#parValueIt = file.get_32()
	#paramValue = file.get_32()
