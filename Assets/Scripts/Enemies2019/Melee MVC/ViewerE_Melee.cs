using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewerE_Melee : MonoBehaviour
{
    public Animator _anim;
    ModelE_Melee _model;
    public List<SkinnedMeshRenderer> myMeshes = new List<SkinnedMeshRenderer>();
    public List<Material> myMats = new List<Material>();
    bool damaged;
    float timeShaderDamage;
    public ParticleSystem sparks;
    public ParticleSystem blood;
    EnemyScreenSpace ess;
    float timeOnDamage;
    bool auxTakeDamage;
    public GameObject prefabTextDamage;
    public Camera cam;

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
        _model = GetComponent<ModelE_Melee>();
        myMeshes.AddRange(GetComponentsInChildren<SkinnedMeshRenderer>());
        ess = GetComponent<EnemyScreenSpace>();

        _anim.SetBool("Idle", true);

        foreach (var item in myMeshes)
        {
            myMats.Add(item.materials[0]);
            item.materials[0].SetFloat("_Intensity", 0);
        }
    }

    void Update()
    {
        DamageShader();

        if (auxTakeDamage)
        {
            timeOnDamage -= Time.deltaTime;
            if (timeOnDamage <= 0)
            {
                _anim.SetBool("TakeDamage", false);
                auxTakeDamage = false;
            }
        }

        if(_model.isDead) foreach (var item in myMats) item.SetFloat("_Intensity", 0);


        
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
        _anim.SetBool("HeavyAttack", true);
        _anim.SetBool("RunAttack", false);
    }

    public void HeavyAttackFalse()
    {
        _anim.SetBool("HeavyAttack", false);
    }

    public void HitDefenceAnim()
    {
        sparks.gameObject.SetActive(true);
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
         _anim.SetBool("WalkBack", false);
        _anim.SetBool("WalkL", false);
        _anim.SetBool("WalkR", false);
        _anim.SetBool("Idle", false);
    }

    public void CombatIdleAnim()
    {
        _anim.SetBool("WalkCombat", false);
        _anim.SetBool("WalkBack", false);
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
        sparks.gameObject.SetActive(true);
        sparks.Play();
        _anim.SetBool("Blocked", true);
    }

    public void WalckBackAnim()
    {
        Debug.Log("back");
        _anim.SetBool("WalkBack", true);
        _anim.SetBool("WalkCombat", false);
        _anim.SetBool("IdleCombat", false);
        _anim.SetBool("Idle", false);
    }

    public void BackFromBlocked()
    {
        _anim.SetBool("Blocked", false);
    }

    public void DeadAnim()
    {
        _anim.SetBool("Dead", true);
    }

    public void DeadBody()
    {
        StartCoroutine(DeadCorrutine());
    }

    public void AttackAnim()
    {
        _anim.SetBool("Attack", true);
        _anim.SetBool("RunAttack", false);
    }

    public void BackFromAttack()
    {
        _anim.SetBool("Attack", false);
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
        _anim.SetBool("TakeDamage", false);       
    }

    public void TakeDamageAnim()
    {
        _anim.SetBool("TakeDamage", true);
        damaged = true;
        timeShaderDamage = 1;
        blood.gameObject.SetActive(true);
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
            var damageText = Instantiate(prefabTextDamage);
            Vector2 screenPos = cam.WorldToScreenPoint(transform.position);
            damageText.transform.position = screenPos;
            damageText.GetComponent<PopText>().damageText = damage;
            float distance = Vector3.Distance(transform.position, cam.transform.position);
            var depthUI = damageText.GetComponent<DepthUI>();
            depthUI.depth = -distance;
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

    public void LifeBar(float val)
    {
        ess.timer = 3;
        StartCoroutine(ess.UpdateLifeBar(val));
    }
}
