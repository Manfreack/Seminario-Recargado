using UnityEngine;
using System.Collections;


public class PropRandomizer : MonoBehaviour {
	public float chanceToDelete = 0.5f;	
	public GameObject[] randomDelete;
	public float maxRotation = 90;
	public GameObject[] randomRotate;
	public float maxOffset = 0.25f;
	public GameObject[] randomSlide;
	
	public void OnEditorPlacement() {
		foreach(var g in randomRotate) {
			g.transform.Rotate(Vector3.up, Random.value*maxRotation*Mathf.Deg2Rad);	
		}
		foreach(var g in randomSlide) {
			g.transform.Translate(Random.value * maxOffset, 0, Random.value * maxOffset, Space.World);
		}
		foreach(var g in randomDelete) {
			if(Random.value <= chanceToDelete) {
				DestroyImmediate(g);	
			}
		}
		DestroyImmediate(this);
	}
}
