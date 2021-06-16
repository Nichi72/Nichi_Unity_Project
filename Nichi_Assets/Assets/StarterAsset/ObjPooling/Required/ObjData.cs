using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[CreateAssetMenu(fileName = "ObjData", menuName = "Scriptable Object Asset/ObjData")]
public class ObjData : ScriptableObject
{
    public string ObjName { get => objName; set => objName = value; }
    public GameObject ModelPrefab { get => modelPrefab; set => modelPrefab = value; }
    public int Weight { get => weight; set => weight = value; }

    [SerializeField] string objName;
    [SerializeField] private GameObject modelPrefab;
    [SerializeField] int weight;


}
