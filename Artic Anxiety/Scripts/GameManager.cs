using Godot;
using System;

public partial class GameManager : Node3D
{
	PackedScene snowBallScene;
	//PackedScene snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Startup");
		snowBallScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/Snowball.tscn");
		GD.Print(snowBallScene);
		snowBallScene.Instantiate();
		GD.Print(snowBallScene);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	public void ThrowSnowball(Vector3 position, Vector3 velocity)
	{
		GD.Print(snowBallScene);
		Node3D snowball = (Node3D)snowBallScene.Instantiate();
		GD.Print(snowball);
		snowball.Position = new Vector3(0, 2, 0);
		//GD.Print("ThrownBeforeAddChild");
		//Node3D abilities = (Node3D)GetNode("Abilities");
		//GD.Print("node abilities found");
		//if(abilities == null)
		//{
		//	GD.Print("abilities is null");
		//}
		AddChildDeferred(snowball);
		GD.Print(snowball.Position);
	}	
	
	private void AddChildDeferred(Node node)
	{
		CallDeferred("add_child", node);
	}
	
}
