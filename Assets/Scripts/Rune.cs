using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rune : MonoBehaviour
{
    public float healingAmount;
    public float cooldownTime;
    public ParticleSystem particles;
    particleAttractorLinear particleAttractor;
    public GameObject runeCircle;
    ButtonManager buttonManager;
    bool used;
    bool useParticles;
    public Material mat;
    Model player;
    public Transform myPH;
    public float timer = 0;

    void Start()
    {
        used = false;
        mat = GetComponent<MeshRenderer>().material;
        player = FindObjectOfType<Model>();
        buttonManager = FindObjectOfType<ButtonManager>();
    }

    void OnTriggerStay(Collider c)
    {

        if (!used && c.GetComponent<Model>())
        {         
            buttonManager.OnNotify(myPH);

            if (player != null)
            {
                if (player.life != player.maxLife || player.stamina != player.maxStamina)
                {
                    if (player.isInCombat)
                    {
                        timer += Time.deltaTime;

                        if (timer > 1) timer = 1;

                        mat.SetFloat("_RuneusedState", timer);

                        runeCircle.SetActive(true);
                        used = true;
                        StartCoroutine(Opacity(false, player));
                        StartCoroutine(Cooldown());
                        StartCoroutine(HealParticlesOpacity());                                                                   
                    }
                    else
                    {
                        StartCoroutine(HealParticlesOpacity());
                        runeCircle.SetActive(true);
                        useParticles = true;
                        player.UpdateLife(healingAmount * Time.deltaTime);
                        player.UpdateStamina(healingAmount * Time.deltaTime);
                    }
                }

                else
                {
                    particles.Stop();
                }
            }
        }
    }

    public void OnTriggerExit(Collider c)
    {
        particles.Stop();
        StartCoroutine(ChangeColorRune());
        if (c.GetComponent<Model>())
        {
            if (!player.isInCombat)
            {
              
                useParticles = false;
            }
        }
    }

    IEnumerator ChangeColorRune()
    {
        while (timer>0)
        {
            timer -= Time.deltaTime;
            mat.SetFloat("_RuneusedState", timer);
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator HealParticlesOpacity()
    {
        particles.Play();
        yield return new WaitForSeconds(2);
        particles.Stop();
        runeCircle.SetActive(false);
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
