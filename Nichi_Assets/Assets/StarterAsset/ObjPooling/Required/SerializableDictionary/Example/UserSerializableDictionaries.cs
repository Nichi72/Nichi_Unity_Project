using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

[Serializable]
public class StringStringDictionary : SerializableDictionary<string, string> {}

[Serializable]
public class ObjectColorDictionary : SerializableDictionary<UnityEngine.Object, Color> {}

[Serializable]
public class ColorArrayStorage : SerializableDictionary.Storage<Color[]> {}

[Serializable]
public class StringColorArrayDictionary : SerializableDictionary<string, Color[], ColorArrayStorage> {}

[Serializable]
public class GameObjArrayStorage : SerializableDictionary.Storage<GameObject[]> { }
[Serializable]
public class StringGameObjArrayDictionary : SerializableDictionary<string, GameObject[], GameObjArrayStorage> { }
[Serializable]
public class GameObjListStorage : SerializableDictionary.Storage<List <GameObject>> { }
[Serializable]
public class StringGameObjListDictionary : SerializableDictionary<string, List<GameObject>, GameObjListStorage> { }

[Serializable]
public class MyClass
{
    public int i;
    public string str;
}

[Serializable]
public class QuaternionMyClassDictionary : SerializableDictionary<Quaternion, MyClass> {}