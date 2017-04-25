using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutlineObject : MonoBehaviour {

	public Color usedColor;

	private Color orgColor;
	private int  orgLayer;
	private Material mat;
	private Shader orgShader;

	// Use this for initialization
	void Start () 
	{
		mat = GetComponentInChildren<Renderer> ().material;
		orgColor = mat.GetColor ("_Color");
		orgShader = mat.shader;
		orgLayer = gameObject.layer;

		#region Regist Outline
		OutlineCamera outline = GameObject.FindObjectOfType<OutlineCamera>();
		if (outline)
		{
			outline.Regist(this);
		}
		#endregion
	}

	public void Activate()
	{
		gameObject.layer = OutlineCamera.UsedLayer;
		mat.shader = OutlineCamera.UsedShader;
		mat.SetColor("_Color", usedColor);
	}

	public void Recover()
	{
		gameObject.layer = orgLayer;
		mat.shader = orgShader;
		mat.SetColor("_Color", orgColor);
	}
}
