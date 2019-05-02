using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelDoor : MonoBehaviour
{

    public LevelManager lm;
    public Animator anim;
  

    private void Start()
    {
        lm = FindObjectOfType<LevelManager>();
        anim = GetComponent<Animator>();
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<Model>() && !lm.playerHasKey)
        {
            lm.SetText(LevelManager.TextImputs.DOOR_CLOSE);
        }

        if (c.GetComponent<Model>() && lm.playerHasKey)
        {
            anim.SetBool("Open", true);
            lm.playerHasKey = false;
        }       
    }


}
