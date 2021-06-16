using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum eCheckDistanceState
{
    None,
    OutAround_Fornt,
    OutAround_Behind,
    InAround_Fornt,
    InAround_Behind
}

public class CheckObjectDistance : MonoBehaviour
{
    /// <summary>
    /// 검사 할 거리
    /// </summary>
    public float CheckDis { get => checkDis; set => checkDis = value; }
    public Action InAroundFrontDel { get => inAroundFrontDel; set => inAroundFrontDel = value; }
    public Action InAroundBehindDel { get => inAroundBehindDel; set => inAroundBehindDel = value; }
    public Action OutAroundFrontDel { get => outAroundFrontDel; set => outAroundFrontDel = value; }
    public Action OutAroundBehindDel { get => outAroundBehindDel; set => outAroundBehindDel = value; }

    [SerializeField] private eCheckDistanceState checkDistanceState = eCheckDistanceState.None;
    [SerializeField] private bool isDebugMode = false;
    [SerializeField] private Transform startTr;
    [SerializeField] private Transform targetTr;
    [SerializeField] private float checkDis; //
    private Vector3 dir;
    private Vector3 normalizedDir;
    [SerializeField] private float distance; // 두 오브젝트 간의 거리 

    public bool isOnly_X_Axis;
    public bool isFrontOfTheObject;
    public bool isInAround;
    

    void Start()
    {
        if(startTr == null)
        {
            startTr = transform;
        }
    }

   
    // Update is called once per frame
    void Update()
    {
        DebugDrawRay();
        CheckFront();
        ChdeckInAround();
        CheckDistanceState();
    }
    Action inAroundFrontDel;
    Action inAroundBehindDel;
    Action outAroundFrontDel;
    Action outAroundBehindDel;
    
    /// <summary>
    /// 생성자
    /// </summary>
    /// <param name="_startTr"></param>
    /// <param name="_targetTr"></param>
    /// <param name="_checkDis"></param>
    /// <param name="_isDebugMode"></param>
    /// <param name="_isOnly_X_Axis"></param>
    public void InitData(Transform _startTr , Transform _targetTr , float _checkDis , bool _isDebugMode ,bool _isOnly_X_Axis)
    {
        startTr = _startTr;
        targetTr = _targetTr;
        checkDis = _checkDis;
        isDebugMode = _isDebugMode;
        isOnly_X_Axis = _isOnly_X_Axis;
    }
   
    void CheckDistanceState()
    {
        if(isInAround == true && isFrontOfTheObject == true)
        {
            checkDistanceState = eCheckDistanceState.InAround_Fornt;
            if (inAroundFrontDel != null)
                inAroundFrontDel();
        }
        else if(isInAround == true && isFrontOfTheObject == false)
        {
            checkDistanceState = eCheckDistanceState.InAround_Behind;
            if (inAroundBehindDel != null)
                inAroundBehindDel();
        }
        else if (isInAround == false && isFrontOfTheObject == true)
        {
            checkDistanceState = eCheckDistanceState.OutAround_Fornt;
            if (outAroundFrontDel != null)
                outAroundFrontDel();
        }
        else if (isInAround == false && isFrontOfTheObject == false)
        {
            checkDistanceState = eCheckDistanceState.OutAround_Behind;
            if (outAroundBehindDel != null)
                outAroundBehindDel();
        }
        else
        {
            checkDistanceState = eCheckDistanceState.None;
        }
    }

    void CheckFront()
    {
        dir = targetTr.position - startTr.position;
        normalizedDir = dir.normalized;
        
        if(isOnly_X_Axis)
        {
            dir = new Vector3(dir.x, 0, 0);
            normalizedDir = dir.normalized;
        }

        if (0 <= dir.x)
        {
            isFrontOfTheObject = true;
        }
        else
        {
            isFrontOfTheObject = false;
        }
    }
    void ChdeckInAround()
    {
        distance = dir.magnitude; // 
        
        if( distance <= checkDis)
        {
            isInAround = true;
        }
        else
        {
            isInAround = false;
        }
    }
   
    void DebugDrawRay()
    {
        if (isDebugMode)
        {
            if(isOnly_X_Axis)
            {
                Debug.DrawRay(startTr.position, normalizedDir * checkDis, Color.blue);
            }
            else
            {
                Debug.DrawRay(startTr.position, normalizedDir * checkDis, Color.red);
            }
        }
    }


}
