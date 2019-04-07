using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenSpaceCanvas : MonoBehaviour {

    List<DepthUI> panels = new List<DepthUI>();

	void Awake () {
        panels.Clear();
	}
	
	void Update () {
        Sort();
	}

    public void AddToCanvas (GameObject obj)
    {
        panels.Add(obj.GetComponent<DepthUI>());
    }

    public void RemoveFromCanvas(GameObject obj)
    {
        panels.Remove(obj.GetComponent<DepthUI>());
    }

    void Sort() {
        panels.Sort((x, y) => x.depth.CompareTo(y.depth));
        for (int i = 0; i < panels.Count; i++)
            panels[i].transform.SetSiblingIndex(i);
    }
}
