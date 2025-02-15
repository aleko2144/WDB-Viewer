class_name WDB_AliasTable extends WDB_DataContainer

#wdb.dsr description:
#( class AliasTable (DataContainer) ("754") ()
#   (
#      ( AliasTableEntry entry ( ITERATED ) )
#   )
#   (
#   )
#)

var entry : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 754

	super(file, loader)
	self.name = "AliasTable_%s" % self.offset_hex
	#self.name = WDB_ASCIIZ.ApplyName(self.object_name, "AliasTable_%s" % self.offset_hex)
	
	while (file.get_position() < data_end_offset):
		#( class AliasTableEntry ( Container ) ("755") ()
		#( ASCIIZ name )
		#( DWORD index )
		#tag (755), size
		file.seek(file.get_position() + 8)
		entry.append([WDB_ASCIIZ.LoadFromBuffer(file), file.get_u32()])
