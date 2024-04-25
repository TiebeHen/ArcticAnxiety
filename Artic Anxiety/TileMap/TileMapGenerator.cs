using Godot;
using System;

public partial class TileMapGenerator : Node3D
{
	[Export]
	public PackedScene Tile;

	public override void _Ready()
	{
					Node3D tile = Tile.Instantiate<Node3D>();
					tile.Translate(new Vector3(0, 0, 0));
					tile.Position = new Vector3(0,0,0);	
					GetTree().Root.AddChild(tile);
	}
}
