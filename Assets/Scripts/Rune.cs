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
    public MeshRenderer mr;
    public Material mat;
    Model player;
    public Transform myPH;
    public float timer = 0;
    bool checkpoint = false;

    bool isHealing = false;

    float t = -1;

    void Start()
    {
        used = false;
        mat = mr.material;
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

                        //mat.SetFloat("_RuneusedState", timer);

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
                        if (!isHealing)
                            StartCoroutine(StartHealEffect());
                    }
                }

                else
                {
                    particles.Stop();
                    if (isHealing)
                        StartCoroutine(StopHealEffect());
                }
            }
        }
    }

    public void OnTriggerExit(Collider c)
    {
        particles.Stop();
        if (isHealing)
            StartCoroutine(StopHealEffect());
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
            //mat.SetFloat("_RuneusedState", timer);
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
        float time = -1;
        while (time < 1)
        {
            time += Time.deltaTime * 2;
            if (show)
                mat.SetFloat("_Fill", time);
            else
            {
                mat.SetFloat("_Fill", 1 - time);
                player.UpdateLife(healingAmount * Time.deltaTime);
                player.UpdateStamina(healingAmount * Time.deltaTime);
                if (!isHealing)
                    StartCoroutine(StartHealEffect());
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

    public IEnumerator Checkpoint()
    {
        float time = -1;
        mat.SetColor("_EmissionColor1", Color.yellow);
        while (time < 1)
        {
            time += Time.deltaTime * 2;
            mat.SetFloat("_Fill", time);
            yield return new WaitForEndOfFrame();
        }
        while (time > -1)
        {
            time -= Time.deltaTime * 2;
            mat.SetFloat("_Fill", time);
            yield return new WaitForEndOfFrame();
        }
        checkpoint = true;
    }

    IEnumerator StartHealEffect()
    {
        isHealing = true;
        while (isHealing && t < 1)
        {
            if (checkpoint)
            {
                t += Time.deltaTime * 2;
                mat.SetColor("_EmissionColor1", Color.green);
                mat.SetFloat("_Fill", t);
            }
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator StopHealEffect()
    {
        isHealing = false;
        while (!isHealing && t > -1)
        {
            if (checkpoint)
            {
                t -= Time.deltaTime * 2;
                mat.SetColor("_EmissionColor1", Color.green);
                mat.SetFloat("_Fill", t);
            }
            yield return new WaitForEndOfFrame();
        }
    }
}
