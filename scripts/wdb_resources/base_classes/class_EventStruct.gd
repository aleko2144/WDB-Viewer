class_name WDB_EventStruct

#wdb.dsr:
#( DWORD type )
#( longInteger param1 )
#( DWORD dataLen )
#( DWORD	param2 ( ( ITERATED dataLen ) ) )

var type    : int
var param1  : int
var dataLen : int
var param2  : Array
	
func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	type = file.get_32()
	param1 = file.get_32()
	dataLen = file.get_32()
	for i in range(dataLen):
		param2.append(file.get_32())
