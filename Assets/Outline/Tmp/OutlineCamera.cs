using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class OutlineCamera : MonoBehaviour {
    [SerializeField]
    private Material mat;
    [SerializeField]
    private string usedLayerName;
    [SerializeField]
    private Shader usedShader;
    [SerializeField]
    [Range(0, 100)]
	private int outlineWidth;

	private List<OutlineObject> objs = new List<OutlineObject>();

	private Camera outlineCamera;
	private RenderTexture renderTexture;

	static private int usedLayer;
	static public int UsedLayer { get { return usedLayer; } }
	static public Shader UsedShader;

	void Awake()
	{
		usedLayer = LayerMask.NameToLayer (usedLayerName);
		UsedShader = usedShader;
	}

	void Start()
	{
		#region Init Camera
		Camera sourceCamera = GetComponent<Camera> ();
		sourceCamera.depthTextureMode = DepthTextureMode.Depth;

		GameObject cameraGameObject = new GameObject("Outline Camera");
		cameraGameObject.transform.parent = sourceCamera.transform;
		outlineCamera = cameraGameObject.AddComponent<Camera>();

		renderTexture = new RenderTexture(sourceCamera.pixelWidth, sourceCamera.pixelHeight, 16, RenderTextureFormat.Default);

		outlineCamera.CopyFrom(sourceCamera);
		outlineCamera.renderingPath = RenderingPath.Forward;
		outlineCamera.backgroundColor = Color.clear;
		outlineCamera.clearFlags = CameraClearFlags.SolidColor;
		outlineCamera.rect = new Rect(0, 0, 1, 1);
		outlineCamera.enabled = false;
		outlineCamera.cullingMask = 1 << usedLayer;
		outlineCamera.targetTexture = renderTexture;
		#endregion
	}

	public void Regist(OutlineObject obj)
	{
		if (obj != null && !objs.Contains (obj)) 
		{
			objs.Add (obj);
		}
	}

	void OnPreRender()
	{
		objs.ForEach (o => o.Activate ());

		outlineCamera.Render ();

		objs.ForEach (o => o.Recover ());
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) 
	{
		Graphics.SetRenderTarget (null);

		mat.SetTexture("_OutlineTexture", renderTexture);
		mat.SetFloat("_OutlineWidth", outlineWidth);

		Graphics.Blit(src, mat);
	}
}
