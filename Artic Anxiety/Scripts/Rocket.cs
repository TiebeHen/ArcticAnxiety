using Godot;
using System;

public partial class Rocket : Node3D
{
	private Vector3 targetPosition;
	private const float speed = 25f; // Adjust as needed
	private	Vector3 _velocity = new Vector3(speed, 0, speed);
	private Level level;
	PackedScene ExplosionScene = ResourceLoader.Load<PackedScene>("res://Scenes/Game/Abilities/explosion.tscn");
	
	
	public override void _Ready()
	{
		level = new Level();
		
		
	}
	
	
	public void SetVelocity(Vector3 velocity)
	{
		_velocity = velocity;
	}

	public void SetTargetPosition(Vector3 targetPos)
	{
		targetPos[1] += (float) 0.35;
		targetPosition = targetPos;
		
	}

	public override void _Process(double delta)
	{
		Vector3 direction = (targetPosition - Position).Normalized();
		Position += direction * speed * (float) delta;
		
		
		LookAt(targetPosition, Vector3.Up);
		
		
		// Check if the rocket is close enough to the target position to be considered as "hit"
		if (Position.DistanceTo(targetPosition) < speed * delta)
		{
			
			//Explo instance = (Explo)ExplosionScene.Instantiate();
			//instance.Position = targetPosition;
			//this.AddChild(instance);
			//Explo.explode();
			
			targetPosition[1] = 0;
			level.DeleteTileWRadius(targetPosition,5);
			
			QueueFree();
		}
	}
}
