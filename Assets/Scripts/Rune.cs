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

    void OnTriggerStay(Collider c)
    {
        if (!used)
        {
            Model p = c.gameObject.GetComponent<Model>();
            if (p != null)
            {
                if(p.life != p.maxLife || p.stamina != p.maxStamina)
                {
                    if (p.isInCombat)
                    {
                        used = true;
                        StartCoroutine(Opacity(false, p));
                        StartCoroutine(Cooldown());
                    }
                    else
                    {
                        p.UpdateLife(healingAmount * Time.deltaTime);
                        p.UpdateStamina(healingAmount * Time.deltaTime);
                    }
                }
            }
        }
    }

    IEnumerator Opacity(bool show, Model player = null)
    {
        float time = 0;
        while (time < 1)
        {
            time += Time.deltaTime;
            if (show)
                mat.SetFloat("_GlobalOpacity", time);
            else
            {
                mat.SetFloat("_GlobalOpacity", 1 - time);
                player.UpdateLife(healingAmount * Time.deltaTime);
                player.UpdateStamina(healingAmount * Time.deltaTime);
            }
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
