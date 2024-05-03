using Godot;
using System;
using System.IO;
using System.Collections.Generic;

public partial class Level : Node3D
{	
	
	List<ClassTile> instances = new List<ClassTile>();
	
	
	//tiles
	PackedScene FullIceTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Level/FullIceTile.tscn");
	PackedScene WaterTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Water/WaterTile.tscn");
	PackedScene SeaBottomTile = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Tiles/Ground/SeaBottomTile.tscn");
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		string filePath = "Assets/Map/Level.txt";
		
		string[] lines = File.ReadAllLines(filePath);
		
		int x = 0;
		int y = 0;
		for (int i = 0; i < lines.Length; i++)
		{
			 string[] values = lines[i].Split(',');
  				
				for (int z = 0; z < values.Length; z++)
				{
					String id = values[z];
					if(id == "49")
					{
						Node3D instance = (Node3D)FullIceTile.Instantiate();
 						instance.Position = new Vector3(x, 0, y);
 						// Verzetten van de blokken x, Hoogte, y
						AddChildDeferred(instance);
						instances.Add(new ClassTile(id,instance));
					
					}	
					else
					{
						instances.Add(new ClassTile(id,null));
					}
						y+=2;
				}
				y= 0;
 				x += 2; // Increment x by 2
		}
		
		
		//for the light blue tiles
		x= -20;
		y = -20;
		for (int i = 0; i < 70; i++)
		{
				for (int z = 0; z < 90; z++)
				{
						Node3D instance = (Node3D)WaterTile.Instantiate();
 						instance.Position = new Vector3(x, (float)-0.5, y);
 						// Verzetten van de blokken x, Hoogte, y
						AddChildDeferred(instance);
						y+=2;
				}
				y= -20;
 				x += 2; // Increment x by 2
		}
		
		//for the Sea Bottom tiles
		x= -20;
		y = -20;
		for (int i = 0; i < 70; i++)
		{
				for (int z = 0; z < 90; z++)
				{
						Node3D instance = (Node3D)SeaBottomTile.Instantiate();
 						instance.Position = new Vector3(x, -5, y);
 						// Verzetten van de blokken x, Hoogte, y
						AddChildDeferred(instance);
						y+=2;
				}
				y= -20;
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
	}
	private void VriesWaterBlok()
	{
		
	}
	
	
		}
