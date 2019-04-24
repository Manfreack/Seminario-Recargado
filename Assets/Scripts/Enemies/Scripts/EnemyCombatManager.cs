using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class EnemyCombatManager : MonoBehaviour {

    public int times;
    public bool flanTicket;
	// Use this for initialization
	void Start () {

        times = 2;
     
	}
    public void Update()
    {
        if (times > 2) times = 2;
    }


}
