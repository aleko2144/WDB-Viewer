class_name WDB_EventQHullOutsideData extends WDB_EventSimpleData

#wdb.dsr:
#( WORD		plane_num	)
#( Plane	planes ( ( ITERATED plane_num ) )   )
#( WORD 	points_num   )
#( Vector	points  ( ( ITERATED points_num ) )   )
#( WORD		edge_index_num   )
#( WORD		indices ( ( ITERATED edge_index_num ) )   )

var plane_num      : int
var planes         : Array
var points_num     : int
var points         : Array
var edge_index_num : int
var indices        : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	plane_num      = file.get_u16()
	for i in range(plane_num):
		planes.append(VectorUtils.LoadDVec4FromBuffer(file))

	points_num     = file.get_u16()
	for i in range(points_num):
		points.append(VectorUtils.LoadDVec3FromBuffer(file))

	edge_index_num = file.get_u16()
	for i in range(edge_index_num):
		indices.append(file.get_u16()) 