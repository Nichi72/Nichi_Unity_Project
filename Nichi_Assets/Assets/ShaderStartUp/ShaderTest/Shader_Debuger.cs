using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shader_Debuger : MonoBehaviour
{
    public string text;
    public GameObject testObj;
    public  Material mat;
    // Start is called before the first frame update
    void Start()
    {
        mat = testObj.GetComponent<SkinnedMeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(":: " + mat.GetFloat(text));
    }
}
