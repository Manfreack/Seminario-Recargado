﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class ViewerE_Melee : MonoBehaviour
{
    public Animator _anim;
    ModelE_Melee _model;
    Model _player;
    public List<SkinnedMeshRenderer> myMeshes = new List<SkinnedMeshRenderer>();
    public List<Material> myMats = new List<Material>();
    bool damaged;
    float timeShaderDamage;
    public ParticleSystem sparks;
    public ParticleSystem blood;
    public GameObject bloodPool;
    public Material matPool;
    EnemyScreenSpace ess;
    float timeOnDamage;
    bool auxTakeDamage;
    public PopText prefabTextDamage;
    GameObject canvas;
    public Transform pechera;
    public Camera cam;
    int attacksCounter;
    public GameObject sword;
    public Material heavyMat;
    public float timeShaderHeavyAttack;
    bool heavyAttackShaderTrigger;
    public string animClipName;
    float timerExpandPool;
    float timerVanishPool;
    float timeToEndCounterAttackAnim;
    float timeToEndHeavyAttackAnim;
    bool slowSpeed;
    public ParticleSystem lightHit;
    public ParticleSystem heavyHit;
    public ParticleSystem lockParticle;
    public CapsuleCollider myCollider;

    public List<Rigidbody> boneRigs = new List<Rigidbody>();
    public List<BoxCollider> boneColliders = new List<BoxCollider>();

    public enum EnemyMeleeAnim {TakeDamage ,TakeDamage2, TakeDamage3, Dead, Attack1, Attack2, Attack3, HeavyAttack, WalkStreaf, Persuit, IdleCombat, Patrol, Retreat, Stuned, Knocked, AttackBlocked, Blocked, CounterAttack, IdleDefence, Idle };

    public Dictionary<EnemyMeleeAnim, string> animDictionary = new Dictionary<EnemyMeleeAnim, string>();

    public IEnumerator ShaderHA_True()
    {
        heavyAttackShaderTrigger = true;

        while (heavyAttackShaderTrigger)
        {
            HeavyAttackShader();
            yield return new WaitForEndOfFrame();
        }
       
    }

    public IEnumerator ShaderHA_False()
    {
        while (timeShaderHeavyAttack > 0)
        {
            HeavyAttackShaderFalse();
            yield return new WaitForEndOfFrame();
        }       
    }

    public IEnumerator BloodPoolAnim()
    {
        while(timerExpandPool<1)
        {
            MatPoolExpand();
            yield return new WaitForEndOfFrame();
        }

        yield return new WaitForSeconds(2.5f);

        while (timerVanishPool< 1)
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

        myCollider.enabled = false;
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

    IEnumerator StopHitParticles()
    {
        yield return new WaitForSeconds(1);
        lightHit.gameObject.SetActive(false);
        heavyHit.gameObject.SetActive(false);
    }

    void Awake()
    {
        _player = FindObjectOfType<Model>();
        heavyMat = sword.GetComponent<SkinnedMeshRenderer>().materials[1];
        _anim = GetComponent<Animator>();
        _model = GetComponent<ModelE_Melee>();
        myMeshes.AddRange(GetComponentsInChildren<SkinnedMeshRenderer>());
        ess = GetComponent<EnemyScreenSpace>();
        canvas = GameObject.Find("Canvas");

       // boneRigs.AddRange(GetComponentsInChildren<Transform>().Where(x => x.gameObject.layer == LayerMask.NameToLayer("Bones")).Where(x => x.GetComponent<Rigidbody>()).Select(x => x.GetComponent<Rigidbody>()));
        //boneColliders.AddRange(GetComponentsInChildren<Transform>().Where(x => x.gameObject.layer == LayerMask.NameToLayer("Bones")).Where(x => x.GetComponent<BoxCollider>()).Select(x => x.GetComponent<BoxCollider>()));

        _anim.SetBool("Idle", true);

        foreach (var item in myMeshes)
        {
            myMats.Add(item.materials[0]);
            item.materials[0].SetFloat("_Intensity", 0);
        }

        var clips = _anim.runtimeAnimatorController.animationClips.ToList();

         //Iterate over the clips and gather their information
         /*int aux = 0;
         foreach (var animClip in clips)
         {
             Debug.Log(animClip.name + ": " + aux++);
         }
         */

        
        animDictionary.Add(EnemyMeleeAnim.Dead, clips[0].name);
        animDictionary.Add(EnemyMeleeAnim.Attack1, clips[1].name);
        animDictionary.Add(EnemyMeleeAnim.HeavyAttack, clips[2].name);
        animDictionary.Add(EnemyMeleeAnim.Attack3, clips[3].name);
        animDictionary.Add(EnemyMeleeAnim.Attack2, clips[4].name);
        animDictionary.Add(EnemyMeleeAnim.Persuit, clips[5].name);
        animDictionary.Add(EnemyMeleeAnim.WalkStreaf, clips[7].name);
        animDictionary.Add(EnemyMeleeAnim.IdleCombat, clips[8].name);
        animDictionary.Add(EnemyMeleeAnim.Patrol, clips[9].name);
        animDictionary.Add(EnemyMeleeAnim.Retreat, clips[10].name);
        animDictionary.Add(EnemyMeleeAnim.Idle, clips[11].name);
        animDictionary.Add(EnemyMeleeAnim.Stuned, clips[13].name);
        animDictionary.Add(EnemyMeleeAnim.Knocked, clips[14].name);
        animDictionary.Add(EnemyMeleeAnim.AttackBlocked, clips[15].name);
        animDictionary.Add(EnemyMeleeAnim.CounterAttack, clips[16].name);
        animDictionary.Add(EnemyMeleeAnim.Blocked, clips[17].name);
        animDictionary.Add(EnemyMeleeAnim.IdleDefence, clips[18].name);
        animDictionary.Add(EnemyMeleeAnim.TakeDamage, clips[19].name);
        animDictionary.Add(EnemyMeleeAnim.TakeDamage2, clips[20].name);
        animDictionary.Add(EnemyMeleeAnim.TakeDamage3, clips[21].name);
    }

    void Update()
    {
        if (_player.targetLocked)
        {
            if (_player.targetLocked.name == transform.name) lockParticle.gameObject.SetActive(true);
            else lockParticle.gameObject.SetActive(false); 
        }

        else lockParticle.gameObject.SetActive(false);

        animClipName = _anim.GetCurrentAnimatorClipInfo(0)[0].clip.name;

        DamageShader();

        if(animClipName != animDictionary[EnemyMeleeAnim.HeavyAttack]) heavyMat.SetFloat("_Opacity", 0);

        if (auxTakeDamage)
        {
            timeOnDamage -= Time.deltaTime;
            if (timeOnDamage <= 0)
            {
                _anim.SetInteger("TakeDamageCounter", 0);
                auxTakeDamage = false;
            }
        }

        if(_model.isDead) foreach (var item in myMats) item.SetFloat("_Intensity", 0);

        if (!_anim.GetBool("HeavyAttack")) HeavyAttackShaderFalse();    

        if (!_model.isKnock) _anim.SetBool("Knocked", false);

        if (animClipName == "EM_CounterAttack")
        {
            timeToEndCounterAttackAnim += Time.deltaTime;
            if (timeToEndCounterAttackAnim >= 0.13f)
            {
                BackFromBlocked();
                CombatIdleAnim();
                timeToEndCounterAttackAnim = 0;
            }
        }
        else timeToEndCounterAttackAnim = 0;


        if (animClipName == "Heavy Attack_EM")
        {
            timeToEndHeavyAttackAnim += Time.deltaTime;
            if (timeToEndHeavyAttackAnim >= 1.23f)
            {
                HeavyAttackFalse();
                CombatIdleAnim();
                timeToEndHeavyAttackAnim = 0;
            }
        }
        else timeToEndHeavyAttackAnim = 0;

        if (_model.timeStuned <= 0 && animClipName == "E_Warrior_Stuned2")
        {
            _model.isStuned = false;
            _model._view.StunedAnimFalse();
        }

    }

    public void LightHitAntisipation()
    {
        lightHit.Clear();
        lightHit.Play();
    }

    public void HeavyHitAntisipation()
    {
        heavyHit.Clear();
        heavyHit.Play();
    }

    public void PerfectBlockedAnim()
    {
        sparks.Play();
      
        _anim.SetBool("PerfectBlocked", true);
    }

    public void PerfectBlockedFalse()
    {
        _anim.SetBool("PerfectBlocked", false);
    }

    public void StunedAnim()
    {
        damaged = true;
        timeShaderDamage = 1;
        _anim.SetBool("Stuned", true);
    }

    public void StunedAnimFalse()
    {
        _anim.SetBool("Stuned", false);
    }

    public void KnockedAnim()
    {
        damaged = true;
        timeShaderDamage = 1;
        _anim.SetBool("Knocked", true);
    }

    public void KnockedAnimFalse()
    {
        _anim.SetBool("Knocked", false);
        _model.isKnock = false;
    }

    public void RunAttackAnim()
    {
        _anim.SetBool("RunAttack", true);
    }

    public void DefenceAnim()
    {
        _anim.SetBool("Defence", true);
    }

    public void DefenceAnimFalse()
    {
        _anim.SetBool("Defence", false);
    }

    public void HeavyAttackAnim()
    {
        StartCoroutine(ShaderHA_True());
        _anim.SetBool("HeavyAttack", true);
        _anim.SetBool("RunAttack", false);
    }

    public void HeavyAttackFalse()
    {
        heavyAttackShaderTrigger = false;
        StartCoroutine(ShaderHA_False());
        _anim.SetBool("HeavyAttack", false);
    }

    public void HitDefenceAnim()
    {
       // sparks.gameObject.SetActive(true);
        sparks.Play();
        _anim.SetBool("HitDefence", true);
    }

    public void HitDefenceAnimFalse()
    {
        _anim.SetBool("HitDefence", false);
    }

    public void CombatWalkAnim()
    {
        _anim.SetBool("WalkCombat", true);
        _anim.SetBool("IdleCombat", false);
        _anim.SetBool("WalkL", false);
        _anim.SetBool("WalkR", false);
        _anim.SetBool("Idle", false);
    }

    public void CombatIdleAnim()
    {
        _anim.SetBool("WalkCombat", false);
        _anim.SetBool("IdleCombat", true);
        _anim.SetBool("WalkL", false);
        _anim.SetBool("WalkR", false);
        _anim.SetBool("Idle", false);
    }

    public void WalkLeftAnim()
    {
        _anim.SetBool("WalkL", true);
        _anim.SetBool("WalkR", false);
    }

    public void WalkRightAnim()
    {
        _anim.SetBool("WalkL", false);
        _anim.SetBool("WalkR", true);

    }

    public void BlockedAnim()
    {
       // sparks.gameObject.SetActive(true);
        sparks.Play();
        _anim.SetBool("Blocked", true);
    }

    public void WalckBackAnim()
    {
        _anim.SetBool("WalkBack", true);
        _anim.SetBool("WalkCombat", false);
        _anim.SetBool("IdleCombat", false);
        _anim.SetBool("Idle", false);
        _anim.SetBool("WalkL", false);
        _anim.SetBool("WalkR", false);
    }

    public void BackFromBlocked()
    {
        _anim.SetBool("Blocked", false);
    }

    public void DeadAnim()
    {
        _anim.SetBool("Dead", true);
        //_anim.enabled = false;

        DeadBody();
        var pool = Instantiate(bloodPool);
        matPool = pool.GetComponent<MeshRenderer>().material;
        pool.transform.forward = transform.forward;
        pool.transform.position = transform.position - transform.forward;
        StartCoroutine(BloodPoolAnim());
    }

    public void DeadBody()
    {
        StartCoroutine(DeadCorrutine());
    }

    public void AttackAnim()
    {
        attacksCounter = 0;
        _anim.SetBool("Attack", true);
        _anim.SetBool("Attack2", true);
        _anim.SetBool("Attack3", true);
        _anim.SetBool("RunAttack", false);
    }

    public void BackFromAttack()
    {
        _anim.SetBool("Attack", false);

        if(_model.damageDone && attacksCounter==1) _anim.SetBool("Attack2", false);

        if(_model.damageDone && attacksCounter==2) _anim.SetBool("Attack3", false);

        attacksCounter++;
    }

    public void EndChainAttack()
    {
        _anim.SetBool("Attack", false);
        _anim.SetBool("Attack2", false);
        _anim.SetBool("Attack3", false);
    }

    public void IdleAnim()
    {

        _anim.SetBool("Idle", true);
        _anim.SetBool("IdleCombat", false);
    }

    public void BackFromIdle()
    {
        _anim.SetBool("Idle", false);
        _anim.SetBool("IdleCombat", false);
    }

    public void BackFromDamage()
    {
        _anim.SetInteger("TakeDamageCounter", 0);
    }

    public void TakeDamageAnim(int index)
    {
        _anim.SetInteger("TakeDamageCounter", index);
        damaged = true;
        timeShaderDamage = 1;
        blood.Stop();
        blood.Play();
        timeOnDamage = 0.5f;
        if (!auxTakeDamage)
        {
            auxTakeDamage = true;          
        }

    }

    public void CreatePopText(float damage)
    {
        if (!_model.isDead)
        {
            PopText text = Instantiate(prefabTextDamage);
            StartCoroutine(FollowEnemy(text));
            text.transform.SetParent(canvas.transform, false);
            text.SetDamage(damage);
        }
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

    public void DamageShader()
    {
        if (damaged && !_model.isDead)
        {
            timeShaderDamage -= Time.deltaTime * 2;

            foreach (var item in myMats) item.SetFloat("_Intensity", timeShaderDamage);

            if (timeShaderDamage <= 0) damaged = false;

        }
    }

    public void HeavyAttackShader()
    {
        timeShaderHeavyAttack += Time.deltaTime * 1.5f;

        if (timeShaderHeavyAttack >= 1) timeShaderHeavyAttack = 1;

        heavyMat.SetFloat("_Opacity", timeShaderHeavyAttack);
    }

    public void HeavyAttackShaderFalse()
    {
        timeShaderHeavyAttack -= Time.deltaTime * 1.5f;

        if (timeShaderHeavyAttack <= 0) timeShaderHeavyAttack = 0;

        heavyMat.SetFloat("_Opacity", timeShaderHeavyAttack);
    }

    public void LifeBar(float val)
    {
        ess.timer = 3;
        StartCoroutine(ess.UpdateLifeBar(val));
    }
}
