class_name WDB_ContainerGridCollision extends WDB_DataContainer

#wdb.dsr description:
#( DWORD num )
#( WORD numGridX )
#( WORD numGridY )
#( double lengthGridX )
#( double lengthGridY )
#( double minZ )
#( double maxZ )
#( Matrix matrix )
#( CollisionGridCell cells (( ITERATED num )))

var num               : int
var numGridX          : int
var numGridY          : int
var lengthGridX       : float
var lengthGridY       : float
var minZ              : float
var maxZ              : float
var matrix            : WDB_Matrix
var cells             : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 332

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "GridCollision_%s" % self.offset_hex)
	
	num               = file.get_u32()
	numGridX          = file.get_u16()
	numGridY          = file.get_u16()
	lengthGridX       = file.get_double()
	lengthGridY       = file.get_double()
	minZ              = file.get_double()
	maxZ              = file.get_double()
	matrix            = WDB_Matrix.new()
	matrix.LoadFromBuffer(file)
	for i in range(num):
		var cell : WDB_CollisionGridCell = WDB_CollisionGridCell.new()
		cell.LoadFromBuffer(file)
		cells.append(cell)
