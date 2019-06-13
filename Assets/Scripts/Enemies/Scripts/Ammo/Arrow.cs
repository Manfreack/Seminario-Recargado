using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Arrow : Munition {

    public float timer;
    Model player;

    public EnemyAmmo ammoAmount;

	// Use this for initialization
	void Start () {

        damage = 10;
        player = FindObjectOfType<Model>();
	}
	
	// Update is called once per frame
	void Update () {

        timer += Time.deltaTime;
        if (timer >= 5) ammoAmount.ReturnBulletToPool(this);

        if (player.onRoll || player.invulnerable) GetComponent<BoxCollider>().isTrigger = true;
        else GetComponent<BoxCollider>().isTrigger = false;

        transform.position += transform.forward * 13 * Time.deltaTime;
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
        if (c.gameObject.GetComponent<Model>()) player.GetDamage(damage,transform,true,false);
        Destroy(gameObject);
    }
}
