using UnityEngine;
using UnityEditor;
using System.Linq;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;

public class DungeonPart
{
	public string category = "NA";
	public string style = "NA";
	public string type = "NA";
	public string path;
	public GameObject item;
	public Texture2D preview;
	
	public GUIContent Icon { 
		get {
			if (preview != null)
				return new GUIContent (preview);
			return new GUIContent (Path.GetFileNameWithoutExtension (path));
		}
	}
}


[CustomEditor(typeof(DungeonMasterKitGrid))]
public class DungeonMasterEditor : Editor
{
	float GRIDSIZE = 2;
	static List<DungeonPart> assets = null;
	static string[] categories = null;
	Vector2 scrollPosition;
	Vector3 center;
	Vector3 lastInstantiate;
	Transform cursor;
	Ray ray;
	static string prefabSaveFolder = "Assets/DungeonMasterKit/Models/Prefabs";
	Vector3 centreOfPlane;
	string[] styles;
	int selectedStyle = 0;
	int selectedCategory = 0;
	DungeonPart[] activeParts;
	DungeonPart activePart;
	
	void HandleRightClick ()
	{
		var e = Event.current;
		//skip if alt held down, as this is rotate view command.
		if (e.alt)
			return;
		
		if (e.control) {
			cursor.GetChild (0).Rotate (Vector3.up, 90, Space.World);	
			e.Use ();
		} else if (e.control && e.shift) {
			cursor.GetChild (0).Rotate (Vector3.up, -90, Space.World);	
			e.Use ();
		} else {
			RaycastHit hit;
			if (Physics.Raycast (ray, out hit)) {
				Undo.RegisterSceneUndo ("Delete");
				DestroyImmediate (hit.collider.gameObject);
			}
			e.Use ();
		}
	}
	
	void HandleKeyDown ()
	{
		var e = Event.current;
		if (e.keyCode == KeyCode.Backspace || e.keyCode == KeyCode.Delete) {
			RaycastHit hit;
			if (Physics.Raycast (ray, out hit)) {
				Undo.RegisterSceneUndo ("Delete");
				DestroyImmediate (hit.collider.gameObject);
			}
			e.Use ();
		}
		if (e.keyCode == KeyCode.LeftBracket) {
			centreOfPlane.y += 1;
		}
		if (e.keyCode == KeyCode.RightBracket) {
			centreOfPlane.y -= 1;
		}
		if (e.keyCode == KeyCode.Period) {
			cursor.GetChild (0).Rotate (Vector3.up, 90, Space.World);	
		}
		if (e.keyCode == KeyCode.Comma) {
			cursor.GetChild (0).Rotate (Vector3.up, -90, Space.World);	
		}
	}
	
	void HandleLeftClick ()
	{
		var e = Event.current;
		//skip if alt held down, as this is rotate view command.
		if (e.alt)
			return;
		
		if (e.shift) {
			AddRowOfPartsToActiveTiles ();
			e.Use ();
			
		} else {
			AddPartToActiveTile ();	
			e.Use ();
		}
		
	}
	
	void OnSceneGUI ()
	{
		Handles.DrawSolidRectangleWithOutline (new Vector3[] {
			new Vector3 (0, 0, 0),
			new Vector3 (0, 0, 2),
			new Vector3 (2, 0, 2),
			new Vector3 (2, 0, 0)
		}, new Color (0, 0, 1, 0.052f), Color.blue);

		var grid = target as DungeonMasterKitGrid;
		if (!grid.enableLevelEditor)
			return;
		var controlID = GUIUtility.GetControlID (FocusType.Passive);
		var e = Event.current;
		CalculateCursorPosition ();
		
		if (e.type == EventType.MouseUp && e.button == 0) {
			HandleLeftClick ();
		}
		if (e.type == EventType.MouseUp && e.button == 1) {
			//This causes problems!
			//HandleRightClick ();
		}
		
		if (e.type == EventType.KeyDown) {
			HandleKeyDown ();	
		}
		
		if (Event.current.type == EventType.Layout) {
			HandleUtility.AddDefaultControl (controlID);
		}
		
		Tools.current = Tool.Move;
	}
	
	void LoadSelectedParts ()
	{
		if (assets != null) {
			categories = (from i in assets select i.category).Distinct ().ToArray ();
			if (selectedCategory >= categories.Length)
				selectedCategory = 0;
			activeParts = (from i in assets where i.category == categories [selectedCategory] select i).ToArray ();
			styles = (from i in activeParts select i.style).Distinct ().ToArray ();
			if (selectedStyle >= styles.Length)
				selectedStyle = 0;
			UpdateThumbs ();
		}
	}

	public void SetActivePart (DungeonPart part)
	{
		var grid = target as DungeonMasterKitGrid;
		activePart = part;
		grid.ClearCursor ();
		var cursor = grid.GetCursorTransform ();	
		
		var g = Instantiate (part.item, cursor.position, part.item.transform.rotation) as GameObject;
		foreach (var c in g.GetComponentsInChildren<Collider>()) {
			DestroyImmediate (c);
		}
		g.transform.parent = cursor;
		SceneView.currentDrawingSceneView.Focus ();
	}
	
	public override void OnInspectorGUI ()
	{
		if (assets == null) {
			LoadAssets ();
		}
			
		
		DrawDefaultInspector ();
		
		var grid = target as DungeonMasterKitGrid;
		
		if (!grid.enableLevelEditor) {
			GUILayout.BeginHorizontal ();
			if (GUILayout.Button ("Create Prefab")) {
				grid.ClearCursor ();
				SaveLevelAsPrefab ();
			}
			
			GUILayout.EndHorizontal ();
		} else {
			if (GUILayout.Button ("Reload Assets")) {
				LoadAssets ();
			}
			LoadSelectedParts ();
		
			GUILayout.Space (8);
		
			GUILayout.BeginHorizontal (); 
			{
				GUILayout.Label ("Category:", GUILayout.Width (96));
				selectedCategory = EditorGUILayout.Popup (selectedCategory, categories);
			}
			GUILayout.EndHorizontal ();
		
			GUILayout.Space (8);
		
			GUILayout.BeginHorizontal ();
			{
				GUILayout.Label ("Style:", GUILayout.Width (96));
				selectedStyle = EditorGUILayout.Popup (selectedStyle, styles);
			}
			GUILayout.EndHorizontal ();
		
		
			scrollPosition = GUILayout.BeginScrollView (scrollPosition);
			{
				var icons = (from i in activeParts where i.style == styles [selectedStyle] select i).ToList ();
				while (icons.Count > 0) {
					GUILayout.BeginHorizontal (); 
					{
					
						for (var x=0; x <3; x++) {
				
							if (icons.Count > 0) {
								var icon = icons [0];
								icons.RemoveAt (0);
								var bc = GUI.backgroundColor;
								if (activePart == icon) 
									GUI.color = Color.green;
								if (GUILayout.Button (icon.Icon)) {
									SetActivePart (icon);
						
								}
								GUI.color = bc;
							} 
				
						}
					}
					GUILayout.EndHorizontal ();
				}
			}
			GUILayout.EndScrollView ();
		}
		
	}

	void CalculateCursorPosition ()
	{
		var grid = target as DungeonMasterKitGrid;
		var plane = new Plane (grid.transform.up, centreOfPlane);
		var e = Event.current;
		
		var pos = e.mousePosition;
		pos.y = Screen.height - pos.y - 34;
		
		ray = Camera.current.ScreenPointToRay (pos);
		float enter;
		if (plane.Raycast (ray, out enter)) {
			center = ray.origin + (ray.direction * enter);
			center.x = (Mathf.Round ((center.x + 1) / GRIDSIZE) * GRIDSIZE) - (GRIDSIZE / 2);
			center.z = (Mathf.Round ((center.z + 1) / GRIDSIZE) * GRIDSIZE) - (GRIDSIZE / 2);
		}
		if (cursor == null)
			cursor = grid.GetCursorTransform (); 
		cursor.position = center;
		
		if (e.type == EventType.Repaint) {
			if (e.shift) {
				DrawSelectionMarker ();
			} else {
				DrawMarker ();
			}
			e.Use ();
		}
	}
	
	void DrawMarker ()
	{ 
		Vector3 c = center;
		Handles.DrawSolidRectangleWithOutline (
			new Vector3[] {
				c + new Vector3 (-1, 0, -1), 
				c + new Vector3 (-1, 0, 1), 
				c + new Vector3 (1, 0, 1), 
				c + new Vector3 (1, 0, -1)
			},
			new Color (0, 1, 0, 0.055f),
			Color.green
		);
		Handles.DrawSolidRectangleWithOutline (
			new Vector3[] {
				c + new Vector3 (-1, -c.y, -1), 
				c + new Vector3 (-1, -c.y, 1), 
				c + new Vector3 (1, -c.y, 1), 
				c + new Vector3 (1, -c.y, -1)
			},
			new Color (0, 1, 0, 0.055f),
			Color.blue
		);
		
	}
	
	void DrawSelectionMarker ()
	{ 
		var start = new Vector3 (Mathf.Min (center.x - 1, lastInstantiate.x - 1), center.y, Mathf.Min (center.z - 1, lastInstantiate.z - 1));
		var end = new Vector3 (Mathf.Max (center.x + 1, lastInstantiate.x + 1), center.y, Mathf.Max (center.z + 1, lastInstantiate.z + 1));
		Handles.DrawSolidRectangleWithOutline (
			new Vector3[] {
				new Vector3 (start.x, center.y, start.z), 
				new Vector3 (start.x, center.y, end.z), 
				new Vector3 (end.x, center.y, end.z), 
				new Vector3 (end.x, center.y, start.z)
			},
			new Color (0, 1, 0, 0.055f),
			Color.blue
		);
		
	}
	
	void SaveLevelAsPrefab ()
	{
		var grid = target as DungeonMasterKitGrid;
		Debug.Log ("Saving to: " + prefabSaveFolder);
		var root = Instantiate (grid.gameObject) as GameObject;
		root.name = grid.gameObject.name;
		foreach (Transform t in root.transform) {
			t.localPosition = new Vector3 (-1, 0, -1);	
		}
		DestroyImmediate (root.GetComponent<DungeonMasterKitGrid> ());
		PrefabUtility.CreatePrefab (AssetDatabase.GenerateUniqueAssetPath (prefabSaveFolder + "/" + root.gameObject.name + ".prefab"), root);
		DestroyImmediate (root);
		Debug.Log ("Saved to: " + prefabSaveFolder);
	}
	
	void AddRowOfPartsToActiveTiles ()
	{
		if (activePart == null)
			return;
		var grid = target as DungeonMasterKitGrid;
		var cursor = grid.GetCursorTransform ();
		if (cursor.childCount == 0)
			return;
		var icon = cursor.GetChild (0);
		
		Undo.RegisterSceneUndo ("Add Many Parts");
		var parent = GetChildForPartCategory ();
		var part = activePart.item;
		var start = new Vector3 (Mathf.Min (center.x, lastInstantiate.x), center.y, Mathf.Min (center.z, lastInstantiate.z));
		var end = new Vector3 (Mathf.Max (center.x, lastInstantiate.x), center.y, Mathf.Max (center.z, lastInstantiate.z));
		var prefab = PrefabUtility.FindPrefabRoot (part);
		for (var x=start.x; x <= end.x; x+=GRIDSIZE) {
			for (var z=start.z; z <= end.z; z+=GRIDSIZE) {
				var tile = new Vector3 (x, center.y, z);
				if (Mathf.Approximately (tile.x, lastInstantiate.x) && Mathf.Approximately (tile.z, lastInstantiate.z))
					continue;
				var g = PrefabUtility.InstantiatePrefab (prefab) as GameObject;	
				foreach (var pr in g.GetComponentsInChildren<PropRandomizer>())
					pr.OnEditorPlacement ();
				foreach (var pr in g.GetComponentsInChildren<PropSwapper>())
					pr.OnEditorPlacement ();
				g.transform.position = tile;
				g.transform.rotation = icon.rotation;
				g.transform.parent = parent;
			}	
		}
		
		lastInstantiate = center;
	}
	
	void AddPartToActiveTile ()
	{
		if (activePart == null)
			return;
		var grid = target as DungeonMasterKitGrid;
		var cursor = grid.GetCursorTransform ();
		if (cursor.childCount == 0)
			return;
		var icon = cursor.GetChild (0);
		
		Undo.RegisterSceneUndo ("Add Part");
		var parent = GetChildForPartCategory ();	
		var part = activePart.item;
		var prefab = PrefabUtility.FindPrefabRoot (part);
		var g = PrefabUtility.InstantiatePrefab (prefab) as GameObject;
		foreach (var pr in g.GetComponentsInChildren<PropRandomizer>())
			pr.OnEditorPlacement ();
		foreach (var pr in g.GetComponentsInChildren<PropSwapper>())
			pr.OnEditorPlacement ();
		g.transform.position = center;
		g.transform.rotation = icon.rotation;
		g.transform.parent = parent;
		lastInstantiate = center;
	}
	
	Transform GetChildForPartCategory ()
	{
		var grid = target as DungeonMasterKitGrid;
		var part = activePart;
		var child = grid.transform.Find (part.category);
		if (child == null) {
			child = new GameObject (part.category).transform;
			child.parent = grid.transform;
			child.localPosition = Vector3.zero;
			child.localRotation = Quaternion.identity;
		}
		return child;
	}
	
	void LoadAssets ()
	{
		var grid = target as DungeonMasterKitGrid;
		centreOfPlane = grid.transform.position;
		assets = new List<DungeonPart> ();
		foreach (var p in  (from i in Directory.GetFiles (Application.dataPath, "*", SearchOption.AllDirectories) where i.Contains ("DungeonMasterKit") && i.Contains("Models") select i)) {
			if (p.EndsWith ("fbx") || p.EndsWith ("prefab")) {
				
				var dirs = p.Split ('/', '\\');
				var folder = dirs [dirs.Length - 2];
				var nameParts = dirs [dirs.Length - 1].Split ('_');
				var path = p.Substring (p.IndexOf ("Assets"));
				var asset = AssetDatabase.LoadAssetAtPath (path, typeof(GameObject)) as GameObject;
				var i = new DungeonPart () { path = path, item = asset, category = folder };
				if (nameParts.Length > 2) {
					i.style = nameParts [1];
					i.type = nameParts [2];
				}
				assets.Add (i);
			}
		}
	}
	
	void UpdateThumbs ()
	{
		if (activeParts != null) {
			foreach (var i in activeParts) {
				if (i.preview == null) {
					var preview = AssetPreview.GetAssetPreview (i.item);
					if (preview != null) {
						i.preview = new Texture2D (preview.width, preview.height, preview.format, false);	
						i.preview.SetPixels (preview.GetPixels ());
						i.preview.Apply ();
					}
				}
			}
		}
	}
	
	
}