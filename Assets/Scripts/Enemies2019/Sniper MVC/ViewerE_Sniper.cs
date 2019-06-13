using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class ViewerE_Sniper : MonoBehaviour
{
    public Animator anim;
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
    public List<ParticleSystem> fireHandsParticles;
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
    bool startFireHands;
    bool auxTakeDamage;
    float timeOnDamage;
    public ParticleSystem heavyHit;

    public enum EnemyWizzardAnims {Attack, Dead, TakeDamage, Move, Idle, CombatIdle, Stuned, StunedIdle, UpFly, UpStuned };

    public Dictionary<EnemyWizzardAnims, string> animDictionary = new Dictionary<EnemyWizzardAnims, string>();

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
        anim = GetComponent<Animator>();
        _model = GetComponent<ModelE_Sniper>();
        _rb = GetComponent<Rigidbody>();
        myMeshes.AddRange(GetComponentsInChildren<SkinnedMeshRenderer>());
		ess = GetComponent<EnemyScreenSpace>();
        fireHandsMat = fireHandsRenderer.materials[2];

        //_model.timeToShoot = 1;
        startFireHands = true;

        foreach (var item in myMeshes)
        {
            myMats.Add(item.materials[0]);
            item.materials[0].SetFloat("_Intensity", 0);
        }


        var clips = anim.runtimeAnimatorController.animationClips.ToList();

        //Iterate over the clips and gather their information
        /* int aux = 0;
         foreach (var animClip in clips)
         {
             Debug.Log(animClip.name + ": " + aux++);
         }
         */

        animDictionary.Add(EnemyWizzardAnims.Attack, clips[0].name);
        animDictionary.Add(EnemyWizzardAnims.Dead, clips[1].name);
        animDictionary.Add(EnemyWizzardAnims.TakeDamage, clips[2].name);
        animDictionary.Add(EnemyWizzardAnims.UpFly, clips[3].name);
        animDictionary.Add(EnemyWizzardAnims.Idle, clips[4].name);
        animDictionary.Add(EnemyWizzardAnims.CombatIdle, clips[5].name);
        animDictionary.Add(EnemyWizzardAnims.Move, clips[6].name);
        animDictionary.Add(EnemyWizzardAnims.Stuned, clips[7].name);
        animDictionary.Add(EnemyWizzardAnims.StunedIdle, clips[8].name);
        animDictionary.Add(EnemyWizzardAnims.UpStuned, clips[9].name);
    }

    // Update is called once per frame

    public void HeavyHitAntisipation()
    {
        heavyHit.Clear();
        heavyHit.Play();
    }

    void Update()
    {
        if (auxTakeDamage)
        {
            timeOnDamage -= Time.deltaTime;
            if (timeOnDamage <= 0)
            {
                anim.SetBool("TakeDamage", false);
                auxTakeDamage = false;
            }
        }

        DamageShader();
        FireHands();
    }

    public void FlyRightAnim()
    {
        anim.SetBool("FlyRight", true);
    }

    public void FlyLeftAnim()
    {
        anim.SetBool("FlyLeft", true);
    }

    public void StunedAnim()
    {
        anim.SetBool("Stuned", true);
        anim.SetBool("FlyLeft", false);
        anim.SetBool("FlyRight", false);
        damaged = true;
        timeShaderDamage = 1;
    }

    public void StunedAnimFalse()
    {
        anim.SetBool("Stuned", false);
        anim.SetBool("FlyLeft", false);
        anim.SetBool("FlyRight", false);
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
        anim.SetBool("Dead", true);
        var pool = Instantiate(bloodPool);
        matPool = pool.GetComponent<MeshRenderer>().material;
        pool.transform.forward = transform.forward;
        pool.transform.position = transform.position - transform.forward/2 + new Vector3(0,0.1f,0);
        StartCoroutine(BloodPoolAnim());
        DeadBody();
    }

    public void DeadBody()
    {
        StartCoroutine(DeadCorrutine());
    }

    public void AttackRangeAnim()
    {
        anim.SetBool("AttackRange", true);
        anim.SetBool("FlyLeft", false);
        anim.SetBool("FlyRight", false);
    }

    public void BackFromAttackRange()
    {
        anim.SetBool("AttackRange", false);
        anim.SetBool("FlyLeft", false);
        anim.SetBool("FlyRight", false);
    }

    public void AttackMeleeAnim()
    {
        StartCoroutine(ShaderMA_True());
        anim.SetBool("AttackMelee", true);
    }

    public void BackFromAttackMelee()
    {
        _shaderMeleeAttackTrigger = false;
        StartCoroutine(ShaderMA_False());
        anim.SetBool("AttackMelee", false);
    }

    public void IdleAnim()
    {
        anim.SetBool("IdleCombat", true);
        anim.SetBool("Move", false);
        anim.SetBool("FlyLeft", false);
        anim.SetBool("FlyRight", false);

    }

    public void BackFromIdle()
    {
        anim.SetBool("IdleCombat", false);
    }

    public void MoveFlyAnim()
    {
        anim.SetBool("Move", true);
        anim.SetBool("IdleCombat", false);
        anim.SetBool("FlyLeft", false);
        anim.SetBool("FlyRight", false);
    }

    public void MoveFlyAnimFalse()
    {
        anim.SetBool("Move", false);
     
    }

    public void BackFromDamage()
    {
        anim.SetBool("TakeDamage", false);
        _model.onDamage = false;
    }

    public void TakeDamageAnim()
    {
        _model.onDamage = true;
        anim.SetBool("TakeDamage", true);
        damaged = true;
        timeShaderDamage = 1;
        blood.gameObject.SetActive(true);
        blood.Stop();
        blood.Play();
        timeOnDamage = 0.25f;
        if (!auxTakeDamage)
        {
            auxTakeDamage = true;
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
     
        if(!startFireHands) foreach(var item in fireHandsParticles) item.Play();

        if (_model.timeToShoot < 1)
        {
            startFireHands = true;

            timeFireHands += Time.deltaTime * 2;
            if (timeFireHands > 1) timeFireHands = 1;

            fireHandsMat.SetFloat("_RangedFireOpacity", timeFireHands);
        }

        if (_model.timeToShoot > 1)
        {
            startFireHands = false;

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
