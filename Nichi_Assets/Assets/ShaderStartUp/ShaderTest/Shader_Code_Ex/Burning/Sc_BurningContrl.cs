using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sc_BurningContrl : MonoBehaviour
{
    public GameObject testObj;
    public Material mat;
    [Range(0,0.01f)]
    public float speed;
    public float cut;
    public float Cut
    {
        get
        {
            return cut;
        }
        set
        {
            
            cut = value;
            cut = Mathf.Clamp(cut, 0, 0.7f);

        }
    }
    private bool reverse = true;
    // Start is called before the first frame update
    void Start()
    {
        mat = testObj.GetComponent<SkinnedMeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.T))
        {
            StartCoroutine(StartBurning());
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (reverse)
            {
                reverse = false;
            }
            else
            {
                reverse = true;
            }
        }
    }

    IEnumerator StartBurning()
    {
        while(true)
        {
            if(reverse)
            {
                Cut += speed;
            }
            else
            {
                Cut -= speed;
            }
            
            mat.SetFloat("_Cut", Cut);
            //yield return new WaitForSeconds(0.1f);
            yield return 0;
        }
        
    }
}
