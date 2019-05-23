using UnityEngine;
using System.Collections;


public class PropSwapper : MonoBehaviour {
	
	public GameObject[] choices;
	
	public void OnEditorPlacement() {
		var choice = Random.Range(0, choices.Length);
		for(var i=0; i<choices.Length; i++) {
			if(choice != i) {
				DestroyImmediate(choices[i]);	
			}
		}
		DestroyImmediate(this);
	}
}
