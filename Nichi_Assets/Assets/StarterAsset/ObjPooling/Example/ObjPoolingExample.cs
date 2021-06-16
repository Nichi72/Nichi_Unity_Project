using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjPoolingExample : MonoBehaviour
{
    
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Alpha1))
        {
            ObjectPooingManager.instance.GetPoolingObjAndReturnTo_Contains_NameWaitSec(eObjecLabel.Example_Single_1, 5);
        }

        if(Input.GetKeyDown(KeyCode.Alpha2))
        {
            ObjectPooingManager.instance.GetPoolingObjAndReturnTo_Contains_NameWaitSec(eObjecLabel.Example_Multi_1, 5);
        }
    }


}
