using Godot;
using System;

public partial class TileMapGenerator : Node
{
	public override void _Ready()
	{
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
					var tile = new Tile();
					tile.Translate(new Vector3(x * 2, 0, y * 2)); // Adjust position based on tile size
					AddChild(tile);
				}
			}
		}
	}
}
