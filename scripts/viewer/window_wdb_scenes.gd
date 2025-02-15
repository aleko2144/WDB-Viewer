extends Window

#	
#var root = $Tree.create_item()
#$Tree.hide_root = true
#var child1 = $Tree.create_item(root)
#var child2 = $Tree.create_item(root)
#var subchild1 = $Tree.create_item(child1)
#subchild1.set_text(0, "Subchild1")

var WDBTreeRoot : TreeItem
var is_window_prepared : bool = false

func changeTreeItemColor(state : bool, item : TreeItem) -> void:
	if (state):
		item.set_custom_color(0, Color8(255, 255, 255))
	else:
		item.set_custom_color(0, Color8(128, 128, 128))
	

func object2tree(item_root : TreeItem, n_parent : Node3D) -> void:
	var tree_item : TreeItem = $WDBTreeView.create_item(item_root)
	#$WDBTreeView.create_item(item_root)
	tree_item.set_text(0, n_parent.name)
	tree_item.collapsed = true
	tree_item.set_metadata(0, n_parent)
	
	changeTreeItemColor(n_parent.visible, tree_item)
	
	for child in n_parent.get_children():
		#такие объекты создаются Godot и в чистом WDB отсутствуют
		if not child.is_class("MeshInstance3D"):
			object2tree(tree_item, child)

func makeTreeView() -> void:
	WDBTreeRoot = $WDBTreeView.create_item()
	$WDBTreeView.hide_root = true
	$WDBTreeView.set_select_mode(Tree.SELECT_MULTI)
	
	var WDBScenes : Node = get_parent().get_parent().get_node('WDBScenes')
	for child in WDBScenes.get_children():
		object2tree(WDBTreeRoot, child)
	
	is_window_prepared = true
	self.title = "WDB Structure View"
	
func showStructWindow() -> void:
	self.show()
	if (!is_window_prepared):
		self.title = "Getting scenes tree... Please wait."
		makeTreeView()

func _on_close_requested() -> void:
	self.hide()

func _on_size_changed() -> void:
	$WDBTreeView.size = self.size

func _on_wdb_tree_view_item_activated() -> void:
	var selected_items : Array
	selected_items.append($WDBTreeView.get_selected())
	
	var next_item : TreeItem = $WDBTreeView.get_next_selected(selected_items[-1])
	while (next_item):
		selected_items.append(next_item)
		next_item = $WDBTreeView.get_next_selected(selected_items[-1])
		
	for item in selected_items:
		var target_node : Node3D = item.get_metadata(0)
		var visible_state : bool = target_node.visible
		visible_state = not visible_state
		target_node.visible = visible_state
		changeTreeItemColor(visible_state, item)
