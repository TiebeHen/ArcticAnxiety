using Godot;
using System;

public partial class Level : Node3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		MeshInstance3D tile = new MeshInstance3D();
					tile.Scale = new Vector3(1,2,3);
					
		Node3D d = GetNode<Node3D>("Level");
		d.AddChild(tile);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
