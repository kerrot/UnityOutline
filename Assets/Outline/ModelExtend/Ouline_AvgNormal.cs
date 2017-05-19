using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Ouline_AvgNormal : MonoBehaviour {

    [SerializeField]
    private Color outlineColor;
    [SerializeField]
    [Range(0, 1)]
    private float outlineWidth;

    GameObject outlineObj;
    Material outlineMat;
    private void Awake()
    {
        if (outlineMat == null)
        {
            outlineMat = new Material(Shader.Find("Custom/Outline_AvgNormal"));
            outlineMat.hideFlags = HideFlags.HideAndDontSave;
        }

        Transform tmpT = transform.FindChild("Outline");
        if (tmpT)
        {
            outlineObj = tmpT.gameObject;
        }

        if (outlineObj == null)
        {
            outlineObj = new GameObject("Outline");
            outlineObj.transform.parent = transform;

            if (GetComponent<MeshFilter>())
            {
                outlineObj.AddComponent<MeshFilter>();
                outlineObj.AddComponent<MeshRenderer>(GetComponent<MeshRenderer>());
                Mesh tmpMesh = (Mesh)Instantiate(GetComponent<MeshFilter>().sharedMesh);
                Extensions.MeshNormalAverage(tmpMesh);
                outlineObj.GetComponent<MeshFilter>().sharedMesh = tmpMesh;
                outlineObj.GetComponent<MeshRenderer>().material = outlineMat;
            }

            if (GetComponent<SkinnedMeshRenderer>())
            {
                outlineObj.AddComponent<SkinnedMeshRenderer>(GetComponent<SkinnedMeshRenderer>());
                Mesh tmpMesh = (Mesh)Instantiate(GetComponent<SkinnedMeshRenderer>().sharedMesh);
                Extensions.MeshNormalAverage(tmpMesh);
                outlineObj.GetComponent<SkinnedMeshRenderer>().sharedMesh = tmpMesh;
                outlineObj.GetComponent<SkinnedMeshRenderer>().material = outlineMat;
            }

            outlineObj.transform.localPosition = Vector3.zero;
            outlineObj.transform.localRotation = Quaternion.identity;
        }
    }

    private void Update()
    {
        if (outlineMat)
        {
            outlineMat.SetColor("_OutlineColor", outlineColor);
            outlineMat.SetFloat("_Outline", outlineWidth);
        }
    }

    private void OnEnable()
    {
        if (outlineObj)
        {
            outlineObj.SetActive(true);
        }
    }

    private void OnDisable()
    {
        if (outlineObj)
        {
            outlineObj.SetActive(false);
        }
    }
}
