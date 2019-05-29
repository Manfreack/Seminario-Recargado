﻿using System.Collections;
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
    public List<ParticleSystem> fireHands = new List<ParticleSystem>();
	EnemyScreenSpace ess;
    Material fireHandsMat;
    public SkinnedMeshRenderer fireHandsRenderer;
    public float timeFireHands;
    public PopText prefabTextDamage;
    GameObject canvas;
    public Camera cam;
    float _timeShaderMeleeAttack;
    bool _shaderMeleeAttackTrigger;
    float timerExpandPool;
    float timerVanishPool;
    public GameObject bloodPool;
    public Material matPool;

    public IEnumerator ShaderMA_True()
    {
        _shaderMeleeAttackTrigger = true;

        foreach (var item in fireHands)
        {
            item.Play();
        }

        while (_shaderMeleeAttackTrigger)
        {
            MeleettackShader();
            yield return new WaitForEndOfFrame();
        }

    }

    public IEnumerator ShaderMA_False()
    {
        while (_timeShaderMeleeAttack > 0)
        {
            MeleeAttackShaderFalse();
            yield return new WaitForEndOfFrame();
        }

        foreach (var item in fireHands)
        {
            item.Stop();
        }
    }

    public IEnumerator BloodPoolAnim()
    {
        while (timerExpandPool < 1)
        {
            MatPoolExpand();
            yield return new WaitForEndOfFrame();
        }

        yield return new WaitForSeconds(2.5f);

        while (timerVanishPool < 1)
        {
            MatPoolVanish();
            yield return new WaitForEndOfFrame();
        }
    }

    public void MatPoolExpand()
    {
        timerExpandPool += Time.deltaTime * 0.5f;
        if (timerExpandPool >= 1) timerExpandPool = 1;
        matPool.SetFloat("_FillAmount", timerExpandPool);
    }

    public void MatPoolVanish()
    {
        timerVanishPool += Time.deltaTime / 2.2f;
        if (timerVanishPool >= 1) timerVanishPool = 1;
        matPool.SetFloat("_Vanish", timerVanishPool);
    }

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
        canvas = GameObject.Find("Canvas");
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

    public void StunedAnim()
    {
        _anim.SetBool("Stuned", true);
    }

    public void StunedAnimFalse()
    {
        _anim.SetBool("Stuned", false);
    }

    public void MeleettackShader()
    {
        fireHandsMat.SetFloat("_RangedFireOpacity", 0);

        _timeShaderMeleeAttack += Time.deltaTime * 2f;

        if (_timeShaderMeleeAttack >= 1) _timeShaderMeleeAttack = 1;

        fireHandsMat.SetFloat("_MeleeFireOpacity", _timeShaderMeleeAttack);
    }

    public void MeleeAttackShaderFalse()
    {
        _timeShaderMeleeAttack -= Time.deltaTime * 2f;

        if (_timeShaderMeleeAttack <= 0) _timeShaderMeleeAttack = 0;

        fireHandsMat.SetFloat("_MeleeFireOpacity", _timeShaderMeleeAttack);
    }

    public void DeadAnim()
    {
        _anim.SetBool("Dead", true);
        var pool = Instantiate(bloodPool);
        matPool = pool.GetComponent<MeshRenderer>().material;
        pool.transform.forward = transform.forward;
        pool.transform.position = transform.position - transform.forward/2 + new Vector3(0,0.1f,0);
        StartCoroutine(BloodPoolAnim());
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
        StartCoroutine(ShaderMA_True());
        _anim.SetBool("AttackMelee", true);
    }

    public void BackFromAttackMelee()
    {
        _shaderMeleeAttackTrigger = false;
        StartCoroutine(ShaderMA_False());
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

    public void CreatePopText(float damage)
    {
        PopText text = Instantiate(prefabTextDamage);
        StartCoroutine(FollowEnemy(text));
        text.transform.SetParent(canvas.transform, false);
        text.SetDamage(damage);
    }

    IEnumerator FollowEnemy(PopText text)
    {
        while (text != null)
        {
            Vector2 screenPos = cam.WorldToScreenPoint(transform.position + (Vector3.up * 2));
            text.transform.position = screenPos;
            yield return new WaitForEndOfFrame();
        }
    }

    public void FireHands()
    {
        if (_model.timeToShoot < 1)
        {
            timeFireHands += Time.deltaTime * 2;
            if (timeFireHands > 1) timeFireHands = 1;

            fireHandsMat.SetFloat("_RangedFireOpacity", timeFireHands);
        }

        if (_model.timeToShoot > 1)
        {
            timeFireHands -= Time.deltaTime * 2;
            if (timeFireHands < 0) timeFireHands = 0;

            fireHandsMat.SetFloat("_RangedFireOpacity", timeFireHands);
        }
    }

    public void LifeBar(float val)
    {
        ess.timer = 3;
        StartCoroutine(ess.UpdateLifeBar(val));
    }
}
