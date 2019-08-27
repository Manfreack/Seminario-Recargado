using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CheckPoint : MonoBehaviour, ICheckObservable
{
    public GameObject interactiveKey;
    public GameObject prefabInteractiveKey;
    public CamController cam;
    public float positionFix;
    Camera myCamera;

    Material mat;    
    public GameObject textCheck;
    public GameObject buttonRespawn;
    public Transform checkTransform;
    public Transform ph;
    public ButtonManager ButtonManager;
    Rune rune;
    bool done = false;
    public GameObject orb;
    public Model player;
    public float timeToMove;
    public bool checkPointActivated;

    public List<CheckPoint> listaChecks = new List<CheckPoint>();
    bool move1;
  
    List<ICheckObserver> _allObservers = new List<ICheckObserver>();

    DepthUI depthUI;
    Canvas canvas;

    IEnumerator AnimationAdjustment()
    {
        player.GetComponent<Controller>().ShutDownControlls(timeToMove + 0.2f + 1);

        float actualTime = 0;

        var playerStartPos = player.transform.position;      

        while (actualTime < timeToMove)
        {
            Quaternion targetRotation;

            var dir = ph.transform.position - player.transform.position;
            dir.y = 0;

            targetRotation = Quaternion.LookRotation(dir, Vector3.up);

            player.transform.rotation = Quaternion.Slerp(player.transform.rotation, targetRotation, 7 * Time.deltaTime);

            player.view.anim.SetBool("trotAnim", true);
            actualTime += Time.deltaTime;
            player.transform.position = Vector3.Lerp(playerStartPos, ph.transform.position,actualTime/timeToMove);

            yield return new WaitForEndOfFrame();

        }

        actualTime = 0;

        while (actualTime < 0.1f)
        {
            Quaternion targetRotation;

            var dir = transform.position - player.transform.position;
            dir.y = 0;

            targetRotation = Quaternion.LookRotation(dir, Vector3.up);

            player.transform.rotation = Quaternion.Slerp(player.transform.rotation, targetRotation, 20 * Time.deltaTime);

            player.view.anim.SetBool("trotAnim", true);
            actualTime += Time.deltaTime;

            yield return new WaitForEndOfFrame();
        }

        player.view.anim.SetBool("trotAnim", false);
        player.view.anim.SetBool("Idle", true);
        player.view.anim.SetBool("InteractRune",true);

        yield return new WaitForSeconds(1);

        player.view.anim.SetBool("InteractRune", false);
        player.view.anim.SetBool("Idle", true);
    }

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
        myCamera = cam.GetComponent<Camera>();
        canvas = FindObjectOfType<Canvas>();
        player = FindObjectOfType<Model>();
        ButtonManager = FindObjectOfType<ButtonManager>();
        listaChecks.AddRange(FindObjectsOfType<CheckPoint>());
        rune = GetComponent<Rune>();

        mat = transform.GetChild(0).GetComponent<Renderer>().material;
        Subscribe(ButtonManager);

        interactiveKey = Instantiate(prefabInteractiveKey);
        interactiveKey.transform.SetParent(canvas.transform, false);
        interactiveKey.SetActive(false);
        depthUI = interactiveKey.GetComponent<DepthUI>();
    }


    public void Update()
    {
        if (player != null  && player.life<=0)
        {
            Respawn();
        }

        Vector3 worldPos = transform.position + Vector3.up * positionFix;
        Vector3 screenPos = myCamera.WorldToScreenPoint(worldPos);
        interactiveKey.transform.position = screenPos;

        float distance = Vector3.Distance(worldPos, cam.transform.position);
        depthUI.depth = -distance;
    }

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<Model>() && !checkPointActivated) interactiveKey.SetActive(true);

        if (c.GetComponent<Model>() && Input.GetKeyDown(KeyCode.F))
        {
            var totarget = (player.transform.position - transform.position).normalized;

            if (Vector3.Dot(totarget, transform.forward) > -0.5f)
            {
                ActivateCheckPoint();
                interactiveKey.SetActive(false);
            }
        }
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.gameObject.GetComponent(typeof(Model)) && !move1 && !done)
        {
            
            player = c.GetComponent<Model>();
            foreach (var item in listaChecks)
            {
                if (item != this) item.player = null;
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
            o.transform.position = Vector3.LerpUnclamped(player.transform.position, initialPos, t);
            o.transform.localScale = new Vector3(t * 0.3f, t * 0.3f, t * 0.3f);
            yield return new WaitForEndOfFrame();
        }
        Destroy(o);
    }

    public void OnTriggerExit (Collider c)
    {
        interactiveKey.SetActive(false);
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

    public void ActivateCheckPoint()
    {
        if (!checkPointActivated)
        {
            StartCoroutine(AnimationAdjustment());
            checkPointActivated = true;
        }
    }
}
