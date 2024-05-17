using Godot;
using System;
using System.IO;
using System.Collections.Generic;
using System.Data.Common;

public partial class GameManager : Node3D
{
	public static List<PlayerInfo> Players = new List<PlayerInfo>();
	PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	[Export]
	PackedScene animatedPlayerScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/AnimatedPlayer.tscn");
	//PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	// Called when the node enters the scene tree for the first time.
	
	
	public override void _Ready()
	{
		int index = 0;
		foreach (var item in Players)
		{
			Node3D currentPlayer =  (Node3D)animatedPlayerScene.Instantiate();
			currentPlayer.Name = item.Id.ToString();
			currentPlayer.SetUpPlayer(item.Name);
			AddChild(currentPlayer);
			foreach (Node3D spawnPoint in GetTree().GetNodesInGroup("PlayerSpawnPoints"))
			{
				if(int.Parse(spawnPoint.Name) == index){
					currentPlayer.GlobalPosition = spawnPoint.GlobalPosition;
				}
			}
			index ++;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	public void ThrowSnowball(Node nodi, Vector3 position, Vector3 velocity)
	{		
		Snowball instance = (Snowball)snowBallScene.Instantiate();
		instance.Position = position;
		instance.SetVelocity(velocity);
		nodi.AddChild(instance);
	}		
	
}
