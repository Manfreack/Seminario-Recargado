using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Arrow : Munition {

    public float timer;

    public EnemyAmmo ammoAmount;

	// Use this for initialization
	void Start () {

        damage = 10;
	}
	
	// Update is called once per frame
	void Update () {

        timer += Time.deltaTime;
        if (timer >= 5) ammoAmount.ReturnBulletToPool(this);
	}

    public void Initialize()
    {
        
    }

    public void Dispose()
    {

    }
    public static void InitializeArrow(Arrow bulletObj)
    {
        bulletObj.gameObject.SetActive(true);
        bulletObj.Initialize();
    }

    public static void DisposeArrow(Arrow bulletObj)
    {
        bulletObj.Dispose();
        bulletObj.gameObject.SetActive(false);
    }

    public void OnCollisionEnter(Collision c)
    {
        if (c.gameObject.GetComponent<Model>()) c.gameObject.GetComponent<Model>().GetDamage(damage,transform,true);
        Destroy(gameObject);
    }
}
