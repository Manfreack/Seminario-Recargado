using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rune : MonoBehaviour
{
    public float healingAmount;
    public float cooldownTime;
    public ParticleSystem particles;
    bool used;
    bool useParticles;
    Material mat;
    Model player;

    void Start()
    {
        used = false;
        mat = transform.GetChild(0).GetComponent<Renderer>().material;
        player = FindObjectOfType<Model>();
        particles = player.view.healParticles;
    }

    void OnTriggerStay(Collider c)
    {

        if (!used && c.GetComponent<Model>())
        {
            if (player != null)
            {
                if (player.life != player.maxLife || player.stamina != player.maxStamina)
                {
                    if (player.isInCombat)
                    {
                        used = true;
                        StartCoroutine(Opacity(false, player));
                        StartCoroutine(Cooldown());
                        StartCoroutine(HealParticlesOpacity());
                    }
                    else
                    {
                        particles.Play();
                        useParticles = true;
                        player.UpdateLife(healingAmount * Time.deltaTime);
                        player.UpdateStamina(healingAmount * Time.deltaTime);
                    }
                }

                else particles.Stop();
            }
        }
    }

    public void OnTriggerExit(Collider c)
    {
        if (c.GetComponent<Model>())
        {
            if (!player.isInCombat)
            {
                particles.Stop();
                useParticles = false;
            }
        }
    }

    IEnumerator HealParticlesOpacity()
    {
        particles.Play();
        yield return new WaitForSeconds(2);
        particles.Stop();
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
