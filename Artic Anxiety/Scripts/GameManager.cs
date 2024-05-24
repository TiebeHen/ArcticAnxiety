using Godot;
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq; // Needed for Cast<>


public partial class GameManager : Node3D
{
	public static List<PlayerInfo> Players = new List<PlayerInfo>();
	PackedScene playerScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/AnimatedPlayer.tscn");
	PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	PackedScene rocketscene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Rocket_Laucher_Rocket.tscn");
	
	public void RPG(Node nodi, Vector3 positionS, Vector3 velocity, Vector3 targetPosition)
	{
	// Instantiate the rocket
	Rocket instance = (Rocket)rocketscene.Instantiate();
	instance.Position = positionS;
	instance.SetTargetPosition(targetPosition);
	instance.SetVelocity(velocity);
	nodi.AddChild(instance);
	}
	
	GDScript OrcaMovementScript =  GD.Load<GDScript>("res://Scripts/OrcaMovement.gd");
	GodotObject OrcaMovementNode;
	GDScript PlayerScript =  GD.Load<GDScript>("res://Scripts/NewAnimationTest.gd");
	GodotObject PlayerNode;
	
	public override void _Ready()
	{
		OrcaMovementNode = (GodotObject)OrcaMovementScript.New(); 
		PlayerNode = (GodotObject)PlayerScript.New(); 
		
		
		int index = 0;
		foreach (var item in Players)
		{
			Node3D currentPlayer = (Node3D)playerScene.Instantiate();
			currentPlayer.Name = item.Id.ToString();
			//currentPlayer.SetUpPlayer(item.Name);
			AddChild(currentPlayer);

			Node3D spawnpointParent = GetNode<Node3D>("PlayerSpawnPoints");
			Godot.Collections.Array<Node> spawnPoints = spawnpointParent.GetChildren(); // Get the array of children nodes
			foreach (Node3D spawnPoint in spawnPoints)
			{
				if (int.Parse(spawnPoint.Name) == index)
				{
					currentPlayer.GlobalPosition = spawnPoint.GlobalPosition;
				}
			}
			index ++;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		OrcaMovementNode.Call("SetPlayerPos", PlayerNode.Call("GetPlayerPos"));
		
	}
	
	public void ThrowSnowball(Node nodi, Vector3 position, Vector3 velocity)
	{
		Snowball instance = (Snowball)snowBallScene.Instantiate();
		instance.Position = position;
		instance.SetVelocity(velocity);
		nodi.AddChild(instance);
	}
	
	
}
