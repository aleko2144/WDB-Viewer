class_name WDB_CollisionGridCell1

#( class CollisionGridCell1 () () ( COMPLICATED )
#   (
#      ( WORD i )
#      ( WORD j )
#      ( WORD num )
#      ( WORD indices (( ITERATED num )))
#   )

var i       : int
var j       : int
var num     : int
var indices : Array
	
func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	i   = file.get_u16()
	j   = file.get_u16()
	num = file.get_u16()
	for k in range(num):
		indices.append(file.get_u16())
