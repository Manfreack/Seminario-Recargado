using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CheckPoint : MonoBehaviour, ICheckObservable
{
    public Model _Player;
    //public Image marco;

    Material mat;    
    public GameObject textCheck;
    public GameObject buttonRespawn;
    public Transform checkTransform;
    public Transform ph;
    public ButtonManager ButtonManager;
    Rune rune;
    bool done = false;
    public GameObject orb;
    public Transform player;

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
        rune = GetComponent<Rune>();

        mat = transform.GetChild(0).GetComponent<Renderer>().material;
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
        if (c.gameObject.GetComponent(typeof(Model)) && !move1 && !done)
        {
            
            _Player = c.GetComponent<Model>();
            foreach (var item in listaChecks)
            {
                if (item != this) item._Player = null;
            }
            ButtonManager.OnNotify(ph);
            StartCoroutine(Messenge());
            StartCoroutine(rune.Checkpoint());
            done = true;
            StartCoroutine(AttractOrb());
        }

    }

    IEnumerator AttractOrb()
    {
        GameObject o = Instantiate(orb);
        Vector3 initialPos = orb.transform.position;
        orb.SetActive(false);
        float t = 1;
        while (t > 0)
        {
            t -= Time.deltaTime / 2;
            o.transform.position = Vector3.LerpUnclamped(player.position, initialPos, t);
            o.transform.localScale = new Vector3(t * 0.3f, t * 0.3f, t * 0.3f);
            yield return new WaitForEndOfFrame();
        }
        Destroy(o);
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
