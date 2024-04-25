using Godot;
using System;

public partial class TileMapGenerator : Node3D
{
	[Export]
	public PackedScene Tile;

	public override void _Ready()
	{
					Node3D tile = Tile.Instantiate<Node3D>();
					tile.Translate(new Vector3(0, 0, 0)); // Adjust position based on tile size
					tile.Position = new Vector3(1,1,1);	
					GetTree().Root.AddChild(tile);
					
		// Parse text file
		string filePath = "res://TileMap/tilemap.txt";
		string[] lines = System.IO.File.ReadAllLines(filePath);	
		
		// Iterate through each line in the file
		for (int y = 0; y < lines.Length; y++)
		{
			string[] values = lines[y].Split(' ');
			for (int x = 0; x < values.Length; x++)
			{
				int id = int.Parse(values[x]);

				// Instantiate tile based on id
				if (id == 0 || id == 1)
				{
				}
			}
		}
	}
}
