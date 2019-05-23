using UnityEngine;
using System.Collections;




public class DungeonMasterKitGrid : MonoBehaviour
{
	public bool enableLevelEditor = true;
		
	public void ClearCursor() {
		var tx = transform.Find("Cursor");
		if(tx != null) {
			DestroyImmediate(tx.gameObject);	
		}
	}
	
	public Transform GetCursorTransform() {
		var tx = transform.Find("Cursor");
		if(tx == null) {
			tx = new GameObject("Cursor").transform;
			tx.parent = transform;
			//tx.gameObject.hideFlags = HideFlags.HideAndDontSave;
		}
		return tx;
	}
	
}

