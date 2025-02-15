class_name WDB_TextureParamStruct

#wdb.dsr:
#( ASCIIZ	paramName )
#( DWORD paramValue )

var paramName  : String
var paramValue : int

func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	paramName  = WDB_ASCIIZ.LoadFromBuffer(file)
	paramValue = file.get_32()
