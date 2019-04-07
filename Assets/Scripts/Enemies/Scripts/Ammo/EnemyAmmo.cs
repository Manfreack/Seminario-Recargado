using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAmmo : MonoBehaviour {

    public Pool<Arrow> arrowsPool;
    public Arrow arrowPrefab;

    // Use this for initialization
    void Start () {

        arrowsPool = new Pool<Arrow>(10, ArrowFactory, Arrow.InitializeArrow, Arrow.DisposeArrow, true);
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public Arrow ArrowFactory()
    {
        Arrow newArrow = Instantiate(arrowPrefab);
        newArrow.transform.SetParent(this.transform);
        return newArrow;
    }

    public void ReturnBulletToPool(Arrow arrow)
    {
        arrow.timer = 0;
        arrowsPool.DisablePoolObject(arrow);
    }
}
