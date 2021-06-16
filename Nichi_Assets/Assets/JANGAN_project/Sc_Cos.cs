using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sc_Cos : MonoBehaviour
{
    public float speed;
    public float length;
    float current;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

      
        current += speed * Time.deltaTime;
        float v = length * Mathf.Cos(current);

        transform.position += new Vector3(0, 0, v);
    }
}
