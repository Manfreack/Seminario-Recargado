using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rune : MonoBehaviour
{
    public float healingAmount;
    public float cooldownTime;
    public ParticleSystem particles;
    particleAttractorLinear particleAttractor;
    public CheckPoint myCheckPoint;
    public ParticleSystem runeCircle;
    ButtonManager buttonManager;
    bool used;
    bool useParticles;
    public MeshRenderer mr;
    Material mat;
    Model player;
    public Transform myPH;
    public float timer = 0;
    bool checkpoint = false;

    bool isHealing = false;

    public GameObject particle1;
    public GameObject particle2;

    public GameObject orb;
    public Transform orbTarget;
    bool effectDone = false;

    float t = 0;

    void Start()
    {
        used = false;
        mat = mr.material;
        player = FindObjectOfType<Model>();
        buttonManager = FindObjectOfType<ButtonManager>();
    }

    void OnTriggerStay(Collider c)
    {
        if (myCheckPoint.checkPointActivated && c.GetComponent<Model>() && effectDone)
        {
            if (player.life != player.maxLife || player.stamina != player.maxStamina)
            {
                player.UpdateLife(healingAmount * Time.deltaTime);
                player.UpdateStamina(healingAmount * Time.deltaTime);

                if (!isHealing)
                {
                    particles.Play();
                    runeCircle.Play();
                    StartCoroutine(StartHealEffect());
                }
            }
            else
            {
                if (isHealing)
                {
                    particles.Stop();
                    runeCircle.Stop();
                    StartCoroutine(StopHealEffect());
                }
            }
        }
    }

    public void ActivateParticles()
    {
        StartCoroutine(DelayParticles());
    }

    IEnumerator DelayParticles()
    {
        particle2.SetActive(false);
        particle1.SetActive(false);
        yield return new WaitForSeconds(2.5f);
        particle1.SetActive(true);
        StartCoroutine(Checkpoint());
        StartCoroutine(myCheckPoint.Message());
        yield return new WaitForSeconds(2);
        particle2.SetActive(true);
        StartCoroutine(AttractOrb());
        effectDone = true;
        yield return new WaitForSeconds(2);
        particle2.SetActive(false);
        particle1.SetActive(false);
    }

    public void OnTriggerExit(Collider c)
    {
        particles.Stop();
        runeCircle.Stop();

        if (isHealing)
            StartCoroutine(StopHealEffect());
    }

    IEnumerator HealParticlesOpacity()
    {
        particles.Play();
        yield return new WaitForSeconds(2);
        particles.Stop();
    }

    public IEnumerator Checkpoint()
    {
        float time = -1;
        while (time < 1)
        {
            time += Time.deltaTime;
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
                t += Time.deltaTime;
                mat.SetFloat("_ColorLerp", t);
                mat.SetFloat("_EmissionIntensity", t + 2);
            }
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator StopHealEffect()
    {
        isHealing = false;
        while (!isHealing && t > 0)
        {
            if (checkpoint)
            {
                t -= Time.deltaTime;
                mat.SetFloat("_ColorLerp", t);
                mat.SetFloat("_EmissionIntensity", t + 2);
            }
            yield return new WaitForEndOfFrame();
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
            o.transform.position = Vector3.LerpUnclamped(orbTarget.transform.position, initialPos, t);
            o.transform.localScale = new Vector3(t * 0.3f, t * 0.3f, t * 0.3f);
            yield return new WaitForEndOfFrame();
        }
        Destroy(o);
        yield return new WaitForEndOfFrame();
    }
}
