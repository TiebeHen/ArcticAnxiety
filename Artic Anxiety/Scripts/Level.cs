using Godot;
using System;
using System.IO;
using System.Collections.Generic;

public partial class Level : Node3D
{

	static List<ClassTile> instances = new List<ClassTile>();

	string ID_WATER_TILE = "105";
	string ID_FULL_ICE_TILE = "49";
	string ID_BROKEN_ICE_TILE = "48";
	
	
	//for the timer of breaking tiles
	double maxTimeTileBreaking = 4;
	double timeLeftTileBreaking = 4;

	//tiles
	PackedScene FullIceTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Level/FullIceTile.tscn");
	PackedScene WaterTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Water/WaterTile.tscn");
	PackedScene SeaBottomTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Ground/SeaBottomTile.tscn");
	PackedScene BrokenIceTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Level/BrokenIceTile.tscn");
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Ready");
		string filePath = "Assets/Map/Level.txt";

		string[] lines = File.ReadAllLines(filePath);

		int x = 0;
		int y = 0;
		for (int i = 0; i < lines.Length - 1; i++)
		{
			string[] values = lines[i].Split(',');

			for (int z = 0; z < values.Length - 1; z++)
			{
				String id = values[z];
				if (id == ID_FULL_ICE_TILE)
				{
					Node3D instance = (Node3D)FullIceTile.Instantiate();
					instance.Position = new Vector3(x, 0, y);
					// Verzetten van de blokken x, Hoogte, y
					AddChildDeferred(instance);
					instances.Add(new ClassTile(id, instance, instance.Position));
				}
				else
				{
					instances.Add(new ClassTile(ID_WATER_TILE, new Vector3(x, 0, y)));
				}
				y += 2;
			}
			y = 0;
			x += 2; // Increment x by 2
		}


		//for the light blue tiles
		x = -20;
		y = -20;
		for (int i = 0; i < 70; i++)
		{
			for (int z = 0; z < 90; z++)
			{
				Node3D instance = (Node3D)WaterTile.Instantiate();
				instance.Position = new Vector3(x, (float)-0.5, y);
				// Verzetten van de blokken x, Hoogte, y
				AddChildDeferred(instance);
				y += 150;
			}
			y = -20;
			x += 150; // Increment x by 2
		}

		//for the Sea Bottom tiles
		x = -20;
		y = -20;
		for (int i = 0; i < 70; i++)
		{
			for (int z = 0; z < 90; z++)
			{
				Node3D instance = (Node3D)SeaBottomTile.Instantiate();
				instance.Position = new Vector3(x, -5, y);
				// Verzetten van de blokken x, Hoogte, y
				AddChildDeferred(instance);
				y += 2;
			}
			y = -20;
			x += 2; // Increment x by 2
		}
		//foreach(Node3D d in instances)
		//{
		//	RemoveChildDeferred(d);
		//}

		//foreach(ClassTile t in instances)
		//{
		//	GD.Print(t.Print());
		//}


		
	}


	// Method to add child node deferred
	private void AddChildDeferred(Node node)
	{
		CallDeferred("add_child", node);
	}
	private void RemoveChildDeferred(Node node)
	{
		CallDeferred("remove_child", node);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		List<ClassTile> newInstances = new List<ClassTile>(); // Create a new list to hold instances to be added
		
		foreach (ClassTile t in instances) // Iterate over a copy of instances to avoid modification during enumeration
		{
			if (t.GetID() == ID_WATER_TILE)//ID_FULL_ICE_TILE ID_WATER_TILE
			{
				if (GD.Randi() % 100000 < 3) // number between 0 and 49, 10% to change to ice
				{
					Node3D instance = (Node3D)FullIceTile.Instantiate();
					instance.Position = t.GetPosition();
					t.SetInstance(instance);
					t.SetID( ID_FULL_ICE_TILE); // Add new instance to the temporary list
					
					AddChildDeferred(instance);
				}
			}
		}

		// Add new instances to the main collection after the loop
		foreach (var newInstance in newInstances)
		{
			instances.Add(newInstance);
		}
		
		
		BreakTiles(delta);
	}
	public void DeleteTile(Vector3 Position)
	{
		float playerX = Position[0];
		float playerZ = Position[2];
		
		foreach (ClassTile i in instances)
		{
			var _pos = i.GetPosition();
			if (Math.Abs(_pos.X - playerX) <= 2 && Math.Abs(_pos.Z - playerZ) <= 2)
			{
				if (i.GetID() != ID_WATER_TILE)//ID_FULL_ICE_TILE ID_WATER_TILE
				{
					Node parent = i.GetInstance().GetParent();
					Godot.Collections.Array<Node> children = i.GetInstance().GetChildren();
					foreach (Node child in children)
					{
							i.GetInstance().RemoveChild(child);
					}
					parent.RemoveChild(i.GetInstance());
					i.SetID(ID_WATER_TILE);
				}
			}
		}
	}
public void DeleteTileWRadius(Vector3 Position, int radius)
	{
		float playerX = Position[0];
		float playerZ = Position[2];
		
		foreach (ClassTile i in instances)
		{
			var _pos = i.GetPosition();
			if (Math.Sqrt(Math.Pow(_pos.X - playerX, 2) + Math.Pow(_pos.Z - playerZ, 2)) <= radius)
			{
				if (i.GetID() != ID_WATER_TILE)//ID_FULL_ICE_TILE ID_WATER_TILE
				{
					Node parent = i.GetInstance().GetParent();
					Godot.Collections.Array<Node> children = i.GetInstance().GetChildren();
					foreach (Node child in children)
					{
							i.GetInstance().RemoveChild(child);
					}
					if(i.GetInstance() != null)
					{
						parent.RemoveChild(i.GetInstance());
					}
					i.SetID(ID_WATER_TILE);
				}
			}
		}
	}
	public void BreakTiles(double delta)
	{
		
		foreach (ClassTile t in instances) // Iterate over a copy of instances to avoid modification during enumeration
		{
					if (t.GetID() == ID_FULL_ICE_TILE)//ID_FULL_ICE_TILE ID_WATER_TILE
					{
						if (GD.Randi() % 300000 < 3) 
						{
							DeleteTileWRadius(t.GetPosition(),1);
					
							Node3D instance = (Node3D)BrokenIceTile.Instantiate();
							instance.Position = t.GetPosition();
							t.SetInstance(instance);
							t.SetID(ID_BROKEN_ICE_TILE); 
					
							AddChildDeferred(instance);
						}
					}
				if(timeLeftTileBreaking < 0)
				{
					if (t.GetID() == ID_BROKEN_ICE_TILE)//ID_FULL_ICE_TILE ID_WATER_TILE
					{
						
						DeleteTileWRadius(t.GetPosition(),1);
					}
					timeLeftTileBreaking = maxTimeTileBreaking;
				}
				timeLeftTileBreaking -= delta;
				
			
			
		}
	}
	
	
	//public List<ClassTile> GetInstances()
	//{
	//return instances;
	//}
	//public String PrintTest()
	//{
	//	return "test voor interlanguage scripten";
	//}


}
