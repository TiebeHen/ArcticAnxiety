using Godot;
using System;

public partial class Level : Node3D
{	
	PackedScene TileScene = ResourceLoader.Load<PackedScene>("res://Level/Tile.tscn");
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Node3D instance = (Node3D)TileScene.Instantiate();
		instance.Position = new Vector3(0,0,0);
		//Node3D level = GetNode<Node3D>(Level");
		//level.AddChild(instance);
		
		
		AddChildDeferred(instance);
}

	// Method to add child node deferred
	private void AddChildDeferred(Node node)
	{
		CallDeferred("add_child", node);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
