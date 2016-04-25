using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Loader : MonoBehaviour {

	public GameObject prefab;
	public int GridX = 3;
	public int GridY = 3;
	public int GridZ = 3;

	// Use this for initialization
	void Start()
	{
		if (prefab != null)
		{
			for (var i1 = -GridX; i1 <= GridX; i1++)
				for (var i2 = -GridY; i2 <= GridY; i2++)
					for (var i3 = -GridZ; i3 <= GridZ; i3++)
					{
						var g = Instantiate(prefab, new Vector3(i1*2, i2*2, i3*2), Quaternion.identity) as GameObject;
						g.transform.parent = this.transform;
					}
		}
	}
}
