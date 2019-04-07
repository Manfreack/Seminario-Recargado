using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Powers : MonoBehaviour {

    public Transform myCaller;
    public GameObject newParticles;
    public Ipower powerAction;
    public IDecorator decoretorAction;
    public bool IsStaticPower;
    public bool IsStaticDecorator;
    public float damage;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

        if (powerAction != null && !IsStaticPower) powerAction.Ipower();
        if (decoretorAction != null && !IsStaticDecorator) decoretorAction.IDecorator();
	}


    public void Initialize()
    {
        transform.position = myCaller.position;
        transform.forward = myCaller.forward;
    }

    public void Dispose()
    {

    }
    public static void InitializePower(Powers bulletObj)
    {
        bulletObj.gameObject.SetActive(true);
        bulletObj.Initialize();
    }

    public static void DisposePower(Powers bulletObj)
    {
        bulletObj.Dispose();
        bulletObj.gameObject.SetActive(false);
    }

    public Powers SetStrategy(Ipower newAction)
    {
        powerAction = newAction;
        newAction.Ipower();
        return this;
    }

    public Powers SetDecorator(IDecorator newDecorator)
    {
        decoretorAction = newDecorator;
        newDecorator.IDecorator();
        return this;
    }

   
}
