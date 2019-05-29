using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rune : MonoBehaviour
{
    public float healingAmount;
    public float cooldownTime;
    bool used;
    Material mat;

    void Start()
    {
        used = false;
        mat = transform.GetChild(0).GetComponent<Renderer>().material;
    }

    void OnTriggerEnter(Collider c)
    {
        if (!used)
        {
            Model player = c.gameObject.GetComponent<Model>();
            if (player)
            {
                if(player.life != player.maxLife)
                {
                    player.UpdateLife(healingAmount);
                    used = true;
                    StartCoroutine(Opacity(false));
                    StartCoroutine(Cooldown());
                }
            }
        }
    }

    IEnumerator Opacity(bool show)
    {
        float time = 0;
        while (time < 1)
        {
            time += Time.deltaTime;
            if (show)
                mat.SetFloat("_GlobalOpacity", time);
            else
                mat.SetFloat("_GlobalOpacity", 1 - time);
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator Cooldown()
    {
        yield return new WaitForSeconds(cooldownTime + 1);
        StartCoroutine(Opacity(true));
        used = false;
    }
}
