using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameMng : MonoBehaviour
{
    public GameObject cubePf;
    public GameObject cubeSpinPf;
    public GameObject cubeUpDown;
    public GameObject objRL;

    int[,] map = new int[15, 15];
    int mapX, mapZ;
    const float MAP_START_POS_X = 7.5f;
    const float MAP_START_POS_Z = 7.5f;

    // Start is called before the first frame update
    void Start()
    {
        iniMap();
        MakeMap();
        MapRecursiveDivision(15,15);
    }

    private void MakeMap()
    {

        Vector3 pos = new Vector3(MAP_START_POS_X, 0, MAP_START_POS_Z);

        for (mapX = 0; mapX < 15; mapX++)
        {
            for (int mapZ = 0; mapZ < 15; mapZ++)
            {

                switch (map[mapX, mapZ])
                {
                    case 1:
                        Instantiate(cubePf, pos, cubePf.transform.rotation);
                        break;
                    case 2:
                        Instantiate(cubeSpinPf, pos, cubeSpinPf.transform.rotation);
                        break;
                    case 3:
                        GameObject objTemp = Instantiate(cubeUpDown, pos, cubeUpDown.transform.rotation);
                        objTemp.GetComponent<Sc_Sin>().speed = UnityEngine.Random.Range(4f, 6f);
                        objTemp.GetComponent<Sc_Sin>().length = UnityEngine.Random.Range(0.05f, 0.15f);
                        break;

                    default: break; // 위 제외 모든것 
                }
                pos += Vector3.forward;

            }
            Vector3 objRLVec = new Vector3(pos.x + 1, 0, MAP_START_POS_Z + MAP_START_POS_Z);
            GameObject objRLTemp = Instantiate(objRL, objRLVec, objRL.transform.rotation);
            objRLTemp.GetComponent<Sc_Cos>().speed = UnityEngine.Random.Range(1f, 2f);
            objRLTemp.GetComponent<Sc_Cos>().length = UnityEngine.Random.Range(0.1f, 0.3f);
            pos.x += 1f; // Z 축 하나 끝냈으니 다음 X 값 
            pos.z = 7.5f;
            

        }
    }



    private void iniMap()
    {
        for (mapX = 0; mapX < 15; mapX++)
        {
            for (int mapZ = 0; mapZ < 15; mapZ++)
            {
                if (mapX % 2 == 1) // 이건 홀수 
                {
                    map[mapX, mapZ] = 0; // 홀수 컬럼이면 블랭크 
                }
                else
                {
                    map[mapX, mapZ] = UnityEngine.Random.Range(0, 4);
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {

    }
    void MapRecursiveDivision(int width, int height) //재귀호출로 맵을 구성
    {
        ClearMap(); //with "1"
        System.Random rand = new System.Random();
        // Generate random r; r for row、c for column
        int r = rand.Next(height);
        while (r % 2 == 0) r = rand.Next(height);
        int c = rand.Next(width); // Generate random c
        while (c % 2 == 0) c = rand.Next(width);
        // Starting cell
        map[r, c] = 0; mapX = height; mapZ = width;
        recursion(r, c);  //　Allocate the maze with recursive method
    }

    public void recursion(int r, int c)
    {
        int[] directions = new int[] { 1, 2, 3, 4 }; // 4 random directions
        Shuffle(directions); //directions <-- generate random directions
        // Examine each direction
        for (int i = 0; i < directions.Length; i++)
        {
            switch (directions[i])
            {
                case 1: // Up, Whether 2 cells up is out or not
                    if (r - 2 <= 0)
                        continue;
                    if (map[r - 2, c] != 0)
                    {
                        map[r - 2, c] = 0;
                        map[r - 1, c] = 0;
                        recursion(r - 2, c);
                    }
                    break;
                case 2: // Right, Whether 2 cells to the right is out or not
                    if (c + 2 >= mapX - 1)
                        continue;
                    if (map[r, c + 2] != 0)
                    {
                        map[r, c + 2] = 0;
                        map[r, c + 1] = 0;
                        recursion(r, c + 2);
                    }
                    break;
                case 3: // Down, Whether 2 cells down is out or not
                    if (r + 2 >= mapZ - 1)
                        continue;
                    if (map[r + 2, c] != 0)
                    {
                        map[r + 2, c] = 0;
                        map[r + 1, c] = 0;
                        recursion(r + 2, c);
                    }
                    break;
                case 4: // Left, Whether 2 cells to the left is out or not
                    if (c - 2 <= 0)
                        continue;
                    if (map[r, c - 2] != 0)
                    {
                        map[r, c - 2] = 0;
                        map[r, c - 1] = 0;
                        recursion(r, c - 2);
                    }
                    break;
            }
        }
    }

    public void Shuffle<T>(T[] array)
    {
        System.Random _random = new System.Random();
        for (int i = array.Length; i > 1; i--)
        {
            // Pick random element to swap.
            int j = _random.Next(i); // 0 <= j <= i-1
            T tmp = array[j];
            array[j] = array[i - 1];
            array[i - 1] = tmp;
        }
    }

    void ClearMap() //with "1"
    {
        for (mapX = 0; mapX < 15; mapX++)
            for (mapZ = 0; mapZ < 15; mapZ++)
                map[mapX, mapZ] = 1;
    }
}
