var mySkin : GUISkin;
var effect01 : GameObject;
var effect02 : GameObject;
var effect03 : GameObject;
var effect04 : GameObject;
var effect05 : GameObject;
var effect06 : GameObject;
var effect07 : GameObject;
var effect08 : GameObject;
var effect09 : GameObject;
var effect10 : GameObject;
var effect11 : GameObject;


function OnGUI ()
{
	GUI.skin = mySkin;
	
	GUI.Label (Rect (70,10,200,30), "FT_BloodEffect_Vol01");

	if(GUI.Button (Rect (10,40,20,20), GUIContent ("", "Blood_Explosion")))
	{	Instantiate(effect01, new Vector3(0, 1.1, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (40,40,20,20), GUIContent ("", "Blood_FallDown")))
	{	Instantiate(effect02, new Vector3(0, 2.1, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (70,40,20,20), GUIContent ("", "Blood_Myst_Cone")))
	{	Instantiate(effect03, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (100,40,20,20), GUIContent ("", "Blood_Myst_Sphere")))
	{	Instantiate(effect04, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (130,40,20,20), GUIContent ("", "Blood_Object")))
	{	Instantiate(effect05, new Vector3(0, 0, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (160,40,20,20), GUIContent ("", "Blood_Splash_Cone")))
	{	Instantiate(effect06, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (190,40,20,20), GUIContent ("", "Blood_Splash_Sphere")))
	{	Instantiate(effect07, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	
	if(GUI.Button (Rect (10,70,20,20), GUIContent ("", "Blood_Splash01")))
	{	Instantiate(effect08, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (40,70,20,20), GUIContent ("", "Blood_Splash02")))
	{	Instantiate(effect09, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (70,70,20,20), GUIContent ("", "Blood_Splash03")))
	{	Instantiate(effect10, new Vector3(0, 1.5, 0), Quaternion.Euler(0, 0, 0));	}
	if(GUI.Button (Rect (100,70,20,20), GUIContent ("", "Blood_Splash04")))
	{	Instantiate(effect11, new Vector3(0, 0.5, 0), Quaternion.Euler(0, 0, 0));	}

	
	GUI.Label (Rect (10,Screen.height-30,200,30), GUI.tooltip);
}