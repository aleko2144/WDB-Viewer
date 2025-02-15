class_name WDB_ContainerVertex extends WDB_DataContainer

#wdb.dsr class description:
#( DWORD vertex_flags ( ( MNEMONICS "FGVF_*") ) )
#( DWORD num )
#( Vertex data ( PARAMETRIZED (ITERATED num) ) )

var vertex_flags : WDB_VertexFlags
var num_verts : int
var vertex_data : Array

#var vertex_split_data : Array #вершины отсортированные по bindex

var verts_packedArray   : PackedVector3Array
var normals_packedArray : PackedVector3Array
var UV_packedArray      : PackedVector2Array
var UV2_packedArray     : PackedVector2Array

var bindex_packedArray   : PackedInt32Array
var diffuse_colorsArray  : PackedColorArray
var specular_colorsArray : PackedColorArray

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	vertex_flags = WDB_VertexFlags.new()
	vertex_flags.GetFromInt(file.get_32())
	num_verts    = file.get_32()
	#breakpoint
	for i in range(num_verts):
		#возможно, это стоит оптимизировать
		var vertex = WDB_Vertex.new()
		vertex.LoadFromBuffer(file, vertex_flags)
		vertex_data.append(vertex)
		
		verts_packedArray.append(Vector3(-vertex.x, vertex.z, vertex.y))
		#verts_packedArray.append(Vector3(vertex.x, vertex.y, vertex.z))
		bindex_packedArray.append(vertex.bindex)
		
		if (vertex_flags.flag_normals):
			#normals_packedArray.append(Vector3(vertex.nx, vertex.ny, vertex.nz))
			normals_packedArray.append(Vector3(-vertex.nx, vertex.nz, vertex.ny))

		if (vertex_flags.flag_uv):
			UV_packedArray.append(Vector2(vertex.UV[0], vertex.UV[1]))
		
		if (vertex_flags.flag_diffuse):
			diffuse_colorsArray.append(vertex.color_diffuse)

		if (vertex_flags.flag_specular):
			specular_colorsArray.append(vertex.color_specular)
			#colors_packedArray.append(vertex.color_specular)
			#UV_packedArray.append(Vector2(vertex.UV[0], vertex.UV[1]))
