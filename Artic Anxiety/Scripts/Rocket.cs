using Godot;
using System;

public partial class Rocket : Node3D
{
	private static Vector3 targetPosition;
	private const float speed = 25f; // Adjust as needed
	private	Vector3 _velocity = new Vector3(speed, 0, speed);
	private Level level;
	private static bool HitTarget = false;
	private static double  maxTimeRocket = 3;
	private static double timeLeftRocket = maxTimeRocket;
	
	public override void _Ready()
	{
		level = new Level();
		HitTarget = false;
		timeLeftRocket = maxTimeRocket;
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
		timeLeftRocket -= delta;
		
		LookAt(targetPosition, Vector3.Up);
		
		
		// Check if the rocket is close enough to the target position to be considered as "hit"
		if (Position.DistanceTo(targetPosition) < speed * delta)
		{
			targetPosition[1] = 0;
			level.DeleteTileWRadius(targetPosition,5);
			HitTarget = true;
			_velocity = Vector3.Zero;
			
			if(timeLeftRocket < 0)
			{
				QueueFree();
			}
		}
	}
	public Vector3 TargetPos()
	{
		if (HitTarget)
		{
			return targetPosition;
		}
		else
		{
			return Vector3.Zero;
		}
	}
	
}
