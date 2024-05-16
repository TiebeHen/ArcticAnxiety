using Godot;
using System;

public partial class ClassTile : Node3D
{
	private Node3D _instance;
	private String _id;
	private Vector3 _position;
	
	public ClassTile(String id, Node3D instance)
	{
		_instance = instance;
		_id = id;
	} 
	public ClassTile(String id, Node3D instance, Vector3 position)
	{
		_instance = instance;
		_id = id;
		_position = position;
	} 
	public ClassTile(String id, Vector3 position)
	{
		_id = id;
		_position = position;
	}
	public Node3D GetInstance()
	{
		return _instance;
	}
	public void SetInstance(Node3D i)
	{
		_instance = i;
	}
	public String GetID()
	{
		return _id;
	}
	public void SetID(String s)
	{
		_id = s;
	}
	public Vector3 GetPosition(){
		return _position;
	}
	public String Print()
	{
		if( _instance != null)
		{
		return "ID: " + _id + " Pos: "+ _instance.Position;
		}
		else
		{
			return "ID: " + _id + " Pos: Null" ;
		}
	}
}
