using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelKey : MonoBehaviour
{
    public LevelManager lm;


    private void Start()
    {
        lm = FindObjectOfType<LevelManager>();
    }

    private void Update()
    {
        transform.Rotate(0, 0, 50 * Time.deltaTime);
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<Model>())
        {
            lm.playerHasKey = true;
            lm.SetText(LevelManager.TextImputs.GET_KEY);
            Destroy(gameObject);
        }
    }
}
