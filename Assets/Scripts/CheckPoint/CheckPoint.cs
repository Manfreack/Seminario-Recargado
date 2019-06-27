using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CheckPoint : MonoBehaviour, ICheckObservable
{
    public Model _Player;
    //public Image marco;
    public GameObject textCheck;
    public GameObject buttonRespawn;
    public Transform checkTransform;
    public Transform ph;
    public ButtonManager ButtonManager;

    public List<CheckPoint> listaChecks = new List<CheckPoint>();
    bool move1;
  
    List<ICheckObserver> _allObservers = new List<ICheckObserver>();


    public IEnumerator Messenge()
    {
        move1 = true;
        textCheck.SetActive(true);
        yield return new WaitForSeconds(4);
        move1 = false;
        textCheck.SetActive(false);          
    }

    public IEnumerator Respawn()
    {
        yield return new WaitForSeconds(2);
        buttonRespawn.SetActive(true);
    }

    void Start ()
    {
        ButtonManager = FindObjectOfType<ButtonManager>();
        listaChecks.AddRange(FindObjectsOfType<CheckPoint>());
        Subscribe(ButtonManager);
    }

    public void Update()
    {
        if (_Player != null  && _Player.life<=0)
        {
            Respawn();
        }              
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.gameObject.GetComponent(typeof(Model)) && !move1)
        {
            
            _Player = c.GetComponent<Model>();
            foreach (var item in listaChecks)
            {
                if (item != this) item._Player = null;
            }
            ButtonManager.OnNotify(ph);
            StartCoroutine(Messenge());
        }

    }

    public void OnTriggerExit (Collider c)
    {

    }

    public void Subscribe(ICheckObserver observer)
    {
        if (!_allObservers.Contains(observer))
            _allObservers.Add(observer);
    }

    public void Unsubscribe(ICheckObserver observer)
    {
        if (_allObservers.Contains(observer))
            _allObservers.Remove(observer);
    }
}
