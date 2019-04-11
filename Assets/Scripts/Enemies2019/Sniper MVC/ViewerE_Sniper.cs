using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewerE_Sniper : MonoBehaviour
{
    Animator _anim;
    ModelE_Sniper _model;
    Rigidbody _rb;
    public List<SkinnedMeshRenderer> myMeshes = new List<SkinnedMeshRenderer>();
    public List<Material> myMats = new List<Material>();
    bool damaged;
    float timeShaderDamage;
    public ParticleSystem blood;
	EnemyScreenSpace ess;
    Material fireHandsMat;
    public SkinnedMeshRenderer fireHandsRenderer;
    public float timeFireHands;

    public IEnumerator DeadCorrutine()
    {
        yield return new WaitForSeconds(3);
        GetComponent<CapsuleCollider>().enabled = false;
        GetComponent<Rigidbody>().useGravity = false;
        float posY = transform.position.y;
        while (posY - 2.1f <= transform.position.y)
        {
            transform.position += Vector3.down * Time.deltaTime * 0.15f;
            if (posY - 2 >= transform.position.y)
                gameObject.SetActive(false);
            yield return new WaitForEndOfFrame();
        }
    }

    void Awake()
    {
        _anim = GetComponent<Animator>();
        _model = GetComponent<ModelE_Sniper>();
        _rb = GetComponent<Rigidbody>();
        myMeshes.AddRange(GetComponentsInChildren<SkinnedMeshRenderer>());
		ess = GetComponent<EnemyScreenSpace>();
        fireHandsMat = fireHandsRenderer.materials[2];

        _anim.SetBool("Idle", true);

        foreach (var item in myMeshes)
        {
            myMats.Add(item.materials[0]);
            item.materials[0].SetFloat("_Intensity", 0);
        }
    }

    // Update is called once per frame
    void Update()
    {

        DamageShader();
        FireHands();
    }

    public void DeadAnim()
    {
        _anim.SetBool("Dead", true);
    }

    public void DeadBody()
    {
        StartCoroutine(DeadCorrutine());
    }

    public void AttackRangeAnim()
    {
        _anim.SetBool("AttackRange", true);
    }

    public void BackFromAttackRange()
    {
        _anim.SetBool("AttackRange", false);
    }

    public void AttackMeleeAnim()
    {
        _anim.SetBool("AttackMelee", true);
    }

    public void BackFromAttackMelee()
    {
        _anim.SetBool("AttackMelee", false);
    }

    public void IdleAnim()
    {
        _anim.SetBool("Idle", true);
    }

    public void BackFromIdle()
    {
        _anim.SetBool("Idle", false);
    }

    public void BackFromDamage()
    {
        _anim.SetBool("TakeDamage", false);
        _model.onDamage = false;
    }

    public void TakeDamageAnim()
    {
        _model.onDamage = true;
        _anim.SetBool("TakeDamage", true);
        damaged = true;
        timeShaderDamage = 1;
        blood.gameObject.SetActive(true);
        blood.Stop();
        blood.Play();
    }

    public void DamageShader()
    {
        if (damaged && !_model.isDead)
        {
            timeShaderDamage -= Time.deltaTime * 2;

            foreach (var item in myMats) item.SetFloat("_Intensity", timeShaderDamage);

            if (timeShaderDamage <= 0) damaged = false;

        }
    }

    public void FireHands()
    {
        if (_model.timeToShoot < 1)
        {
            timeFireHands += Time.deltaTime * 2;
            if (timeFireHands > 1) timeFireHands = 1;

            fireHandsMat.SetFloat("_GlobalOpacity", timeFireHands);
        }

        if (_model.timeToShoot > 1)
        {
            timeFireHands -= Time.deltaTime * 2;
            if (timeFireHands < 0) timeFireHands = 0;

            fireHandsMat.SetFloat("_GlobalOpacity", timeFireHands);
        }
    }

    public void LifeBar(float val)
    {
        ess.timer = 3;
        StartCoroutine(ess.UpdateLifeBar(val));
    }
}
