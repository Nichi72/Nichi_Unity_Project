using System.Collections;
using System.Collections.Generic;
using UnityEngine;


// eObjecLabel 요소와 게임 오브젝트 이름은 같아야한다. 
public enum eObjecLabel
{
    None,
    Example_Single_1,
    Example_Multi_1,

    End,
}
[System.Serializable]
public class SerializeDicStringArr : SerializeDictionary<string, GameObject []> { }

public class ObjectPooingManager : MonoBehaviour
{
    // Start is called before the first frame update

    public static ObjectPooingManager instance = null;
    [Header(" == Prefabs == ")]
    [SerializeField] GameObject emptyPrefab; // 빈 오브젝트
    [SerializeField] GameObject exampleSinglePrefab;
   

    [Header("== Scriptable Type Prefabs == ")]
    [Header(" Obj Read Only Resources  ")]
    [SerializeField] List<ObjData> exampleMulti_1_Data = new List<ObjData>();
    [SerializeField] string exampleMulti_1_DataPath = "Data/Example";

    // datas objPool
    public StringGameObjListDictionary objPool;
    public StringGameObjArrayDictionary objPoolTempArr;

    int totalRandomWeight;

    private void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
        // 단일 오브젝트 생성 
        InitSingleObject(eObjecLabel.Example_Single_1, exampleSinglePrefab, 20);

        // 스크립터블 ObjData를 통해 생성
        InitMultiObject(eObjecLabel.Example_Multi_1, exampleMulti_1_Data, 20, exampleMulti_1_DataPath);
    }
    void Start()
    {
        
   

    }

    /// <summary>
    /// 단일 오브젝트 풀링
    /// </summary>
    /// <param name="enumLabel"></param>
    /// <param name="obj"></param>
    /// <param name="count"></param>
    void InitSingleObject(eObjecLabel enumLabel, GameObject obj , int count)
    {
        string key = enumLabel.ToString();
        GameObject initedParent = Instantiate(emptyPrefab,transform);
        objPool[key] = new List<GameObject>();
        objPoolTempArr[key] = new GameObject[count];
        initedParent.transform.name = $"{key}_Parent";
        for (int i = 0; i < count; i++)
        {
            GameObject gameObjTemp = Instantiate(obj, initedParent.transform);
            gameObjTemp.name = $"{key}_{i}";
            gameObjTemp.SetActive(false);
            
            objPool[key].Add(gameObjTemp);
            objPoolTempArr[key][i] = gameObjTemp;
        }
    }

    void InitMultiObject(eObjecLabel enumLabel, List<ObjData> dataList, int count , string loadPath)
    {
        SetObjData(dataList,loadPath);
        InitMulti_Rand_ScriptableObj(enumLabel, dataList, count);
    }
    void SetObjData(List<ObjData> dataList, string load)
    {
        // 스크립터블 오브젝트 동적 할당
        var loadedSpawnObj = Resources.LoadAll(load);
        if(loadedSpawnObj == null)
        {
            Debug.LogError("디텍토리에 ObjData가 없거나 디텍토리가 잘못됐습니다. 경로 , 디텍토리 이름을 확인해주세요");
        }
        for (int i = 0; i < loadedSpawnObj.Length; i++)
        {
            dataList.Add(loadedSpawnObj[i] as ObjData);
        }
        // 가중치 합산
        for (int i = 0; i < dataList.Count; i++)
        {
            // 스크립트가 활성화 되면 카드 덱의 모든 카드의 총 가중치를 구해줍니다.
            totalRandomWeight += dataList[i].Weight;
        }
    }
    void InitMulti_Rand_ScriptableObj(eObjecLabel enumLabel, List<ObjData> dataList, int count)
    {
        string key = enumLabel.ToString(); // 사용할 key 초기화
        GameObject initedParent = Instantiate(emptyPrefab, transform); // 최상위 부모 빈 오브젝트 생성
        objPool[key] = new List<GameObject>(); // Dic List 할당 
        objPoolTempArr[key] = new GameObject[count]; // Dic Arr 할당 
        initedParent.transform.name = $"{key}_Parent"; // // 최상위 부모 이름 설정

        for (int cntIdx = 0; cntIdx < count; cntIdx++)
        {
            ObjData tempObjData = GetObjDataWeightRand(dataList);
            GameObject gameObjTemp = Instantiate(tempObjData.ModelPrefab, initedParent.transform);
            gameObjTemp.name = $"{key}_{tempObjData.ObjName}_{cntIdx}";
            gameObjTemp.SetActive(false);

            objPool[key].Add(gameObjTemp);
            objPoolTempArr[key][cntIdx] = gameObjTemp;
        }

        totalRandomWeight = 0; // 초기화
    }
    
    private ObjData GetObjDataWeightRand(List<ObjData> dataList)
    {
        int weight = 0;
        int selectNum = 0;
        selectNum = Mathf.RoundToInt(totalRandomWeight * Random.Range(0.0f, 1.0f));
        for (int i = 0; i < dataList.Count; i++)
        {
            weight += dataList[i].Weight;
            if (selectNum <= weight)
            {
                return dataList[i];
            }
        }
        Debug.Assert(true, "InitRandomSpawnObj Null");
        return null;
    }
    public GameObject GetPoolingObjAndReturnTo_Contains_NameWaitSec(eObjecLabel enumLabel , float time)
    {
       GameObject objTemp = GetPoolingObj(enumLabel);
       StartCoroutine(ReturnTo_Contains_NameWaitSec(time, objTemp));
       return objTemp;
    }
    public GameObject GetPoolingObj(eObjecLabel enumLabel)
    {
        string label = enumLabel.ToString();
        GameObject getObj= objPool[label][0];
        objPool[label].RemoveAt(0);
        getObj.SetActive(true);
        return getObj;
    }
    public void ReturnPoolingObjToContainsName(GameObject obj)
    {
        eObjecLabel serch = eObjecLabel.None;
        for (int i = 0; i < (int)eObjecLabel.End; i++)
        {
            string stringTemp = serch.ToString();
            if (obj.transform.name.Contains(stringTemp))
            {
                objPool[stringTemp].Add(obj);
                obj.SetActive(false);
                break;
            }
            else
            {
                serch++;
            }
        }
    }
    public void ReturnPoolingObjToEqualsName(GameObject obj)
    {
        eObjecLabel serch = eObjecLabel.None;
        for (int i = 0; i < (int)eObjecLabel.End; i++)
        {
            string stringTemp = serch.ToString();
            if (obj.transform.name.Equals(stringTemp))
            {
                objPool[stringTemp].Add(obj);
                obj.SetActive(false);
                break;
            }
            else
            {
                serch++;
            }
        }
    }

    public IEnumerator ReturnTo_Contains_NameWaitSec(float time , GameObject returnObj)
    {
        yield return new WaitForSeconds(time);
        ReturnPoolingObjToContainsName(returnObj);
    }
    public IEnumerator ReturnTo_Equals_NameWaitSec(float time, GameObject returnObj)
    {
        yield return new WaitForSeconds(time);
        ReturnPoolingObjToEqualsName(returnObj);
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.O)) // ForTest
        {
            
        }
    }
}



