using Godot;
using System;

public partial class penguin_model : Node3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
            
    }    

        // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
	{
        if (Input.IsKeyPressed(Key.B))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("BeginGlijden");
        }
        if (Input.IsKeyPressed(Key.G))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("Glijden");
        }
        if (Input.IsKeyPressed(Key.U))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("GlijdenJump");
        }
        if (Input.IsKeyPressed(Key.Y))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("IdleAnimation");
        }
        if (Input.IsKeyPressed(Key.T))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("IdleJump");
        }
        if (Input.IsKeyPressed(Key.R))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("SneeuwbalGooien");
        }
        if (Input.IsKeyPressed(Key.E))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("StoppenGlijden");
        }
        if (Input.IsKeyPressed(Key.W))
        {
            ((AnimationPlayer)GetNode("AnimationPlayer")).Play("VictoryDance");
        }
        else
        { }

        // MISSCHIEN WAT CLEANER MAAR KAN DE APP NIET BUILDEN

        //switch (true)
        //{
        //    case var _ when Input.IsKeyPressed(Key.B):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("BeginGlijden");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.G):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("Glijden");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.U):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("GlijdenJump");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.Y):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("IdleAnimation");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.T):  
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("IdleJump");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.R):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("SneeuwbalGooien");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.E):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("StoppenGlijden");
        //        break;
        //    case var _ when Input.IsKeyPressed(Key.W):
        //        ((AnimationPlayer)GetNode("AnimationPlayer")).Play("VictoryDance");
        //        break;

        //}

    }
}

