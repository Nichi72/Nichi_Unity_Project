using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sc_Sin : MonoBehaviour
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
        float h = length * Mathf.Sin(current);

        transform.position += new Vector3(0, h, 0);


    }
}
