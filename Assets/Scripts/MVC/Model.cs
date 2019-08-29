﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class Model : MonoBehaviour
{

    public Viewer view;
    EnemyCombatManager ECM;
    public List<EnemyEntity> enemiesToLock = new List<EnemyEntity>();
    public EnemyEntity targetLocked;
    public bool targetLockedOn;
    public int lockIndex;
    public LayerMask layerEnemies;
    EnemyEntity snapTarget;

    public float distanceAggressiveNodes;
    public float distanceNon_AggressiveNodes;
    public CombatNodesManager nodesManager;
    public List<CombatNode> combatNodesArea = new List<CombatNode>();

    public Transform pointerParent;
    public Transform pointerParent2;
    public EnemyPointer pointerPrefab;
    public Pool<EnemyPointer> pointerPool;

    public float radiusAttack;
    public float angleToAttack;
    public float extraFireDamage;
    public float extraSlameDamage;
    public float skillPoints;

    [Header("Player Life:")]

    public float life;
    public float maxLife;

    [Header("Player Speed:")]

    public float speed;
    public float runSpeed;
    public float acceleration;
    public float maxAcceleration;

    [Header("Player Combat:")]

    public float timeOnCombat;
    public float timeToHeal;
    public float maxTimeToHeal;
    public float lifeRecoveredForSec;
    public float lifeRecoveredForSecInCombat;
    public float maxTimeOnCombat;
    public float timeToRoll;
    public bool invulnerable;
    bool makingDamage;

    [Header("Player Powers")]

    public float timeCdPower2;
    public float damagePower2;
    public float reduceTimePerHit;

    [Header("Player ParryStats:")]

    public float perfectParryTimer;

    [Header("Player StaminaStats:")]

    public float stamina;
    public float maxStamina;
    public float mana;
    public float maxMana;
    public float recoveryMana;
    public float armor;
    public float maxArmor;
    public bool armorActive;
    public float runStamina;
    public float attackStamina;
    public float powerStamina;
    public float rollStamina;
    public float recoveryStamina;
    public float recoveryStaminaInCombat;
    public float blockStamina;

    [Header("Player Damage:")]

    public float timeAnimCombat;
    public float attackDamage;
    public float attack1Damage;
    public float attack2Damage;
    public float attack3Damage;
    public float attack4Damage;
    public float attackRollDamage;

    public int[] potions = new int[5];
    public IPotionEffect currentPotionEffect;
    IPotionEffect[] potionEffects = new IPotionEffect[5];

    public int countAnimAttack;
    public Collider enemy;

    Vector3 lastPosition;
    Vector3 dirToRotateAttack;
    float timeToRotateAttack;

    public int stocadaAmount;

    public bool isIdle;
    public bool onPowerState;
    public bool isRuning;
    public bool isInCombat;
    public bool isDead;
    public bool onDefence;
    public bool onRoll;
    public bool saveSword;
    public bool onCounterAttack;
    bool impulse;
    bool starChangeDirAttack;

    public bool cdPower1;
    bool cdPower2;
    bool cdPower3;
    bool cdPower4;
    public bool InAction;
    public bool InActionAttack;
    bool WraperInAction;
    bool dieOnce;
    public bool stuned;

    public bool onDamage;

    public Transform mainCamera;
    public Vector3 dir;
    public Rigidbody rb;

    Platform currentPlatform;
    public bool isPlatformJumping;

    public Action Trot;
    public Action Run;
    public Action Estocada;
    public event Action Attack;
    public event Action RotateAttack;
    public Action SaltoyGolpe1;
    public Action SaltoyGolpe2;
    public Action Uppercut;
    public Action OnDamage;
    public Action Fall;
    public Action Dead;
    public Action BlockEvent;
    public Action RollEvent;
    public Action DefenceEvent;
    public Action StopDefenceEvent;
    public Action StreakEvent;
    public Action RollAttackEvent;
    public Action CounterAttackEvent;
    public Action DogeLeftEvent;
    public Action DogeRightEvent;
    public Action DogeBackEvent;

    public Transform closestEnemy;
    public LayerMask enemyLM;
    bool checking;
    bool timeToRotate;
    Vector3 dirToDahs;
    public float impulseForce;

    float timeImpulse;
    float timeEndImpulse;
    public float internCdPower2;
    public string animClipName;
    public string animClipName2;

    public bool defenceBroken;
    public bool onDash;
    float canRollAttackTimer;
    public float maxTimeToRecoverDefence;
    public float timeToRecoverDefence;
    float tdefence;
    float amountOfPointers;
    bool cheatAnimClip;

    //[HideInInspector]
    public float fadeTimer;
    public enum DogeDirecctions {Left,Right,Back, Roll };
    public DogeDirecctions dirToDash;

    IEnumerator DelayCheatAnimClip()
    {
        cheatAnimClip = true;
        yield return new WaitForSeconds(0.5f);
        cheatAnimClip = false;
    }

    IEnumerator DashTimer()
    {
        yield return new WaitForSeconds(0.2f);
        onDash = false;
    }

    IEnumerator OnRollDealy(float time)
    {
        onRoll = true;
        yield return new WaitForSeconds(time);
        onRoll = false;
    }

    IEnumerator CanRollAttackCorrutine()
    {
        canRollAttackTimer = 3;

        while(canRollAttackTimer>0)
        {
            canRollAttackTimer -= Time.deltaTime;
            yield return new WaitForEndOfFrame();
        }
    }

    public IEnumerator InvulnerableCorrutine()
    {
        invulnerable = true;
        yield return new WaitForSeconds(0.5f);
        invulnerable = false;
    }

    public IEnumerator DefenceBroken()
    {
        timeToRecoverDefence = maxTimeToRecoverDefence;
        defenceBroken = true;

        while (defenceBroken)
        {
            timeToRecoverDefence -= Time.deltaTime;

            tdefence += Time.deltaTime;

            view.BrokenDefence(1 - (tdefence / maxTimeToRecoverDefence));

            if (timeToRecoverDefence <= 0)
            {
                tdefence = 0;
                timeToRecoverDefence = maxTimeToRecoverDefence;
                defenceBroken = false;
            }
            yield return new WaitForEndOfFrame();
        }
    }

    public IEnumerator PowerDelayImpulse(float timeStart, float timeEnd, float time1, float time2)
    {
        yield return new WaitForSeconds(timeStart + timeEnd);
        timeImpulse = time1;
        timeEndImpulse = time2;
        StartCoroutine(ImpulseAttackAnimation());
        view.StreakFalse();
    }

    public IEnumerator GetHeavyDamage()
    {
        stuned = true;
        yield return new WaitForSeconds(2);
        stuned = false;
    } 

    public IEnumerator RollImpulseCorrutine()
    {
        while(timeToRoll>0)
        {
            RollImpulse();
            yield return new WaitForEndOfFrame();
        }

        view.EndDodge();

        while (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Roll])
        {
           
            view.anim.SetFloat("RollTime", timeToRoll);

            if (timeToRoll <= 0)
            {
                onDash = false;
                view.anim.SetBool("Roll", false);
                view.EndDodge();

            }
            yield return new WaitForEndOfFrame();
        }

        view.RollAttackAnimFalse();
    }

    public IEnumerator OnDefenceCorrutine()
    {
        if (!targetLockedOn)
        {
            while (onDefence && !view.anim.GetBool("CounterAttack"))
            {
                var defenceDir = mainCamera.transform.forward;
                defenceDir.y = 0;
                Quaternion targetRotation;
                targetRotation = Quaternion.LookRotation(defenceDir, Vector3.up);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                yield return new WaitForEndOfFrame();
            }
        }
    }

    public IEnumerator OnDamageCorrutine()
    {
        onDamage = true;
        while (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.TakeDamage3] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.TakeDamage2] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.TakeDamage1])
        {
      
            view.anim.SetBool("Roll", false);
            view.anim.SetBool("RollAttack", false);
            yield return new WaitForEndOfFrame();
        }

        onDamage = false;
    }

    public IEnumerator ImpulseAttackAnimation()
    {
        while (timeEndImpulse>0)
        {
            timeImpulse -= Time.deltaTime;

            if (timeImpulse < 0)
            {
                timeEndImpulse -= Time.deltaTime;
                if (timeEndImpulse > 0)
                {
                    if (onDamage) timeEndImpulse = 0;
                    if (countAnimAttack == 2) transform.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * (impulseForce + 1) * Time.deltaTime, 2);
                    if (countAnimAttack == 1) transform.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * (impulseForce / 2) * Time.deltaTime, 2);
                    if (countAnimAttack == 3 || countAnimAttack == 4) transform.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * impulseForce * Time.deltaTime, 2);
                    if (countAnimAttack == 0) transform.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * impulseForce * Time.deltaTime, 2);
                    
                }
            }
            yield return new WaitForEndOfFrame();
        }
    }

    public IEnumerator TimeToDoDamage()
    {
        makingDamage = true;

        while (makingDamage)
        {
            if (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack1_Damage] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack2_Damage]
                || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack3_Damage] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack4_Damage])
            {
                MakeDamage("Normal");               
                timeToRoll = 0;
            }
            yield return new WaitForEndOfFrame();
        }
    }

    public IEnumerator PowerColdown(float cdTime, int n)
    {
        float t1;
        float t2;
        float t3;
        float t4;

        for (t1 = 0; t1 < cdTime && n == 1; t1 += Time.deltaTime)
        {
            cdPower1 = true;
            view.UpdatePowerCD(n, t1 / cdTime);
            yield return new WaitForEndOfFrame();
        }
        for (t2 = 0; t2 < cdTime && n == 2; t2 += Time.deltaTime)
        {
            cdPower2 = true;
            if (cdPower2)
            {
                timeCdPower2 -= Time.deltaTime;
                if (timeCdPower2 <= 0)
                {
                    cdPower2 = false;
                }
            }
            if (timeCdPower2 <= 0) timeCdPower2 = internCdPower2;
            view.UpdatePowerCD(n, t2 / cdTime);
            yield return new WaitForEndOfFrame();
        }
        for (t3 = 0; t3 < cdTime && n == 3; t3 += Time.deltaTime)
        {
            cdPower3 = true;
            view.UpdatePowerCD(n, t3 / cdTime);
            yield return new WaitForEndOfFrame();
        }
        for (t4 = 0; t4 < cdTime && n == 4; t4 += Time.deltaTime)
        {
            cdPower4 = true;
            view.UpdatePowerCD(n, t4 / cdTime);
            yield return new WaitForEndOfFrame();
        }

        if (n == 1 && t1 >= cdTime)
        {
            cdPower1 = false;
            view.UpdatePowerCD(n, 1);
        }
        if (n == 2 && t2 >= cdTime)
        {
            cdPower2 = false;
            view.UpdatePowerCD(n, 1);
        }
        if (n == 3 && t3 >= cdTime)
        {
            cdPower3 = false;
            view.UpdatePowerCD(n, 1);
        }
        if (n == 4 && t4 >= cdTime)
        {
            cdPower4 = false;
            view.UpdatePowerCD(n, 1);
        }

        while (cdPower2)
        {
            timeCdPower2 -= Time.deltaTime;
            if (timeCdPower2 <= 0)
            {
                cdPower2 = false;
            }
        }

        if (timeCdPower2 <= 0) timeCdPower2 = internCdPower2;
    }

    public IEnumerator CombatDelayState()
    {
        yield return new WaitForSeconds(0.4f);
        CombatState();
    }

    public IEnumerator AttackRotation()
    {
        timeToRotateAttack = 0.3f;

        if (!targetLockedOn)
        {
            while (timeToRotateAttack > 0)
            {
                timeToRotateAttack -= Time.deltaTime;
                dirToRotateAttack.y = 0;
                Quaternion targetRotation;
                if (dirToRotateAttack != Vector3.zero)
                {
                    targetRotation = Quaternion.LookRotation(dirToRotateAttack, Vector3.up);
                    transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                }
                yield return new WaitForEndOfFrame();
            }
        }
    }

    public enum PotionName { Health, Stamina, Extra_Health, Costless_Hit, Mana };

   

    private void Awake()
    {
        ModifyNodes();
    }


    void Start()
    {
        ECM = FindObjectOfType<EnemyCombatManager>();
        timeOnCombat = -1;
        rb = GetComponent<Rigidbody>();
        pointerPool = new Pool<EnemyPointer>(5, PointerFactory, EnemyPointer.InitializePointer, EnemyPointer.DisposePointer, true);
        timeToRecoverDefence = maxTimeToRecoverDefence;
        for (int i = 0; i < 2; i++)
            view.UpdatePotions(i);
        potionEffects[1] = new ExtraHealth(this, 60);
        currentPotionEffect = null;
        checking = false;
        fadeTimer = 0;
        internCdPower2 = timeCdPower2;
    }

    void Update()
    {
     
        CombatParameters();

        WraperAction();      

        if (!isRuning && !onPowerState && !onDamage && !isDead && !onRoll && !onDefence)
        {
            float prevS = stamina;

            if(isInCombat) stamina += recoveryStaminaInCombat * Time.deltaTime;

            else stamina += recoveryStamina * Time.deltaTime;

            if (stamina > maxStamina)
                stamina = maxStamina;
            if (prevS != stamina)
                view.UpdateStaminaBar(stamina / maxStamina);
        }

        if(isRuning && !isInCombat)
        {
            stamina += recoveryStamina * Time.deltaTime;
            view.UpdateStaminaBar(stamina / maxStamina);
        }

        float prevM = mana;
        mana += recoveryMana * Time.deltaTime;
        if (mana > maxMana)
            mana = maxMana;
        if (prevM != mana)
            view.UpdateManaBar(mana / maxMana);

        if (stamina <= 0)
        {
            isRuning = false;
            view.FalseRunAnim();
        }

        if (currentPotionEffect != null)
            currentPotionEffect.PotionEffect();

        if (view.anim.GetCurrentAnimatorClipInfo(0)[0].clip != null) animClipName = view.anim.GetCurrentAnimatorClipInfo(0)[0].clip.name;
        if (view.anim.GetCurrentAnimatorClipInfo(1)[0].clip != null) animClipName2 = view.anim.GetCurrentAnimatorClipInfo(1)[0].clip.name;



        if (stamina<5)
        {
            StopDefence();
            view.NoDefence();
        }

        if (fadeTimer < view.fadeTime && !isDead) fadeTimer += Time.deltaTime;

        if (timeToRoll <= 0)
        {
            timeToRoll = 0;
            view.EndDodge();
        }

        if (timeToRoll>0)
        {
            timeToRoll -= Time.deltaTime;
            if (timeToRoll <= 0)
            {
                timeToRoll = 0;
                view.EndDodge();
            }
            view.anim.SetFloat("RollTime", timeToRoll);
        }
    }

    public void ModifyNodes()
    {
       
        var aggresisveNodes = Physics.OverlapSphere(transform.position, distanceAggressiveNodes).Where(x => x.GetComponent<CombatNode>()).Select(x => x.GetComponent<CombatNode>());

        if (aggresisveNodes.Count() > 0)
        {
            foreach (var item in aggresisveNodes)
            {
                item.aggressive = true;
            }
        }

        var non_AggresisveNodes = Physics.OverlapSphere(transform.position, distanceNon_AggressiveNodes).Where(x => x.GetComponent<CombatNode>()).Select(x => x.GetComponent<CombatNode>());

        if (non_AggresisveNodes.Count() > 0)
        {
            foreach (var item in non_AggresisveNodes)
            {
                if (!item.aggressive) item.Non_Aggressive = true;
            }
        }
     
    }

   
    public void Roll(Vector3 dir, DogeDirecctions directions )
    {
        EndCombo();

        dirToDash = directions;

      
        if (stamina - rollStamina >= 0 && !onRoll && animClipName2 != "Idel Whit Sword sheathe" && !view.anim.GetBool("SaveSword2") 
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Roll] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] 
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Back]
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Left] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Right]
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.TakeDamage1] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.TakeDamage2] 
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.TakeDamage3] || (view.attacking && !onRoll))
        {

            StartCoroutine(InvulnerableCorrutine());

            if (directions == DogeDirecctions.Roll)
            {
                if (isInCombat) StartCoroutine(CanRollAttackCorrutine());
                RollEvent();              
                timeToRoll = 0.75f;               
            }

            if (isInCombat)
            {
                if (directions == DogeDirecctions.Left)
                {
                    onDash = true;
                    StartCoroutine(DashTimer());
                    DogeLeftEvent();
                    timeToRoll = 0.2f;
                    StartCoroutine(OnRollDealy(0.5f));
                }

                if (directions == DogeDirecctions.Right)
                {
                    onDash = true;
                    StartCoroutine(DashTimer());
                    DogeRightEvent();
                    timeToRoll = 0.2f;
                    StartCoroutine(OnRollDealy(0.5f));
                }

                if (directions == DogeDirecctions.Back)
                {
                    onDash = true;
                    StartCoroutine(DashTimer());
                    DogeBackEvent();
                    timeToRoll = 0.2f;
                    StartCoroutine(OnRollDealy(0.5f));
                }
            }

            stamina -= rollStamina;
            view.UpdateStaminaBar(stamina / maxStamina);           
            dirToDahs = dir;
            dirToDahs.y = 0;
            makingDamage = false;
            impulse = false;
            
            view.anim.SetFloat("RollTime", timeToRoll);
            lastPosition = transform.position;
            StartCoroutine(RollImpulseCorrutine());
        }
    } 

    public void CombatParameters()
    {
        if (targetLocked)
        {
            if (targetLockedOn)
            {
                var dir = (targetLocked.transform.position - transform.position).normalized;
                dir.y = 0;
                Quaternion targetRotation;
                targetRotation = Quaternion.LookRotation(dir, Vector3.up);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
            }

            if (targetLocked.isDead && targetLocked || isDead)
            {
                enemiesToLock.Remove(targetLocked);

                if (enemiesToLock.Count <= 0)
                {
                    mainCamera.GetComponent<CamController>().StopLockedTarget();
                    targetLocked = null;
                    targetLockedOn = false;
                }
                
                if (enemiesToLock.Count > 0) ChangeTarget();
                           
            }

        }

        timeOnCombat -= Time.deltaTime;
        if (timeOnCombat > 0)
        {

            view.anim.SetBool("IsInCombat", true);
        }

        if (timeOnCombat <= 0) timeOnCombat = 0;

        if (timeOnCombat <= 0 && isInCombat && (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.IdleCombat] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkW] 
            || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkS] ||  animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkA] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkD]))
        {
            view.SaveSwordAnim2();
            view.anim.SetBool("IdleCombat", false);
            view.anim.SetBool("IsInCombat", false);
            view.anim.SetBool("Roll", false);
            InAction = false;
            InActionAttack = false;
            onRoll = false;
            isInCombat = false;
            saveSword = false;
            onDash = false;
        }
    }

    public void RollImpulse()
    {
        if (animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage] && animClipName != "P_RollEstocada_End" && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Roll])
        {        
            view.RollAttackAnimFalse();
        }
        if (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage] 
            || animClipName == "P_RollEstocada_End" || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Roll] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Back] 
            || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Left] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Right] || view.attacking || timeToRoll<=1.4f)
        {
            view.NoReciveDamage();
         
            if(animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Roll])
            {
               
                transform.position += transform.forward * 6 * Time.deltaTime;
            }

            if (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack])
            {
               
                if (!targetLockedOn)
                {
                    Quaternion targetRotation;
                    var dir = mainCamera.transform.forward;
                    dir.y = 0;
                    targetRotation = Quaternion.LookRotation(dir, Vector3.up);
                    transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                    transform.position += transform.forward * 5 * Time.deltaTime;
                }

                else
                {
                    
                    transform.position += transform.forward * 5 * Time.deltaTime;
                }
            }

            if (animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Roll])
            {
                if (dirToDash == DogeDirecctions.Back || dirToDash == DogeDirecctions.Right || dirToDash == DogeDirecctions.Left)
                {
                   if(!view.attacking) transform.position += dirToDahs * 5 * Time.deltaTime;
                   
                   else transform.position += dirToDahs * 7 * Time.deltaTime;
                }

                else transform.position += dirToDahs * 4 * Time.deltaTime;
      
                var dir = mainCamera.transform.forward;

                dir.y = 0;

                transform.forward = dir;
            }

            view.anim.SetFloat("RollTime", timeToRoll);

            if (timeToRoll <= 0f)
            {
                onDash = false;
                view.anim.SetBool("Roll", false);
                view.EndDodge();          
            }            
        }
    }

    public void DrinkPotion(int i)
    {
        bool isFull = false;
        i -= 1;

        if (potions[i] == 0 || currentPotionEffect != null)
            return;

        if (i == (int)PotionName.Health)
        {
            isFull = life == maxLife;
            if(!isFull)
                potionEffects[i] = new Health(this, life, maxLife);
        }
        else
            if (i == (int)PotionName.Stamina)
            {
                isFull = stamina == maxStamina;
                if (!isFull)
                    potionEffects[i] = new Stamina(this, stamina, maxStamina);
            }


        if (!isFull)
        {
            potions[i]--;
            view.UpdatePotions(i);
            currentPotionEffect = potionEffects[i];
        }
    }

    public void CastPower2()
    {
        if (!cdPower2 && !onPowerState && !onDamage && !isDead && !onRoll && stamina - powerStamina >= 0 && isInCombat && !onDefence && !view.anim.GetBool("Parry"))
        {
            EndCombo();
            onRoll = false;
            view.BackRollAnim();
            view.RollAttackAnimFalse();
            timeCdPower2 = internCdPower2;
            stamina -= powerStamina;
            view.UpdateStaminaBar(stamina / maxStamina);
            StreakEvent();
            CombatState();
            timeImpulse = 0.6f;
            timeEndImpulse = 0.2f;
            StartCoroutine(ImpulseAttackAnimation());
            StartCoroutine(PowerDelayImpulse(0.2f, 0.2f, 0.1f, 0.2f));
            StartCoroutine(PowerColdown(timeCdPower2, 2));            
        }
    }

    public void Movement(Vector3 dir)
    {
        view.anim.SetBool("Idle", false);
        acceleration += 3f * Time.deltaTime;
        if (acceleration > maxAcceleration) acceleration = maxAcceleration;

        if (!InAction && !onDamage && countAnimAttack == 0 && !onRoll && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Roll] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack])
        {          
            Quaternion targetRotation;

            if (!isRuning)
            {
               Trot();          
              
               dir.y = 0;
               targetRotation = Quaternion.LookRotation(dir, Vector3.up);
               transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
               rb.MovePosition(rb.position + dir * acceleration * speed * Time.deltaTime);
            }

            else
            {
                Run();
                dir.y = 0;
                targetRotation = Quaternion.LookRotation(dir, Vector3.up);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                rb.MovePosition(rb.position + dir * acceleration * runSpeed * Time.deltaTime);
            }
        }
        
    }

    public void CombatMovement(Vector3 dir, bool key, bool rotate, bool diagonalBack)
    {
        ECM.UpdateEnemyAggressive();

        if (isRuning && !onDefence)
        {
            stamina -= runStamina * Time.deltaTime;
            view.UpdateStaminaBar(stamina / maxStamina);
        }

        acceleration += 3 * Time.deltaTime;
        if (acceleration > maxAcceleration) acceleration = maxAcceleration;

        if ((animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.IdleCombat] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkW] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkS]
           || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkD] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkA] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RunCombat] 
           || (!view.attacking && timeToRoll<=0.5f)) && targetLockedOn && !onDefence)
        {

           rb.MovePosition(rb.position + dir * acceleration * speed * Time.deltaTime);

        }
 
        if ((animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.IdleCombat] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkW] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkS]
            || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkD] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkA] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RunCombat] 
            || (!view.attacking && timeToRoll <= 0.5f)) && !targetLockedOn && !onDefence)
        { 

            EndCombo();

            Quaternion targetRotation;

            if (!isRuning)
            {
               

                Trot();

                if (key)
                {
                   
                    dir.y = 0;
                    targetRotation = Quaternion.LookRotation(dir, Vector3.up);
                    transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                }

                if (diagonalBack)
                {

                    dir.y = 0;
                    targetRotation = Quaternion.LookRotation(-dir, Vector3.up);
                    transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                }

                if (rotate)
                {
                    var camDir = mainCamera.forward;
                    camDir.y = 0;
                    targetRotation = Quaternion.LookRotation(camDir, Vector3.up);
                    transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                }

                rb.MovePosition(rb.position + dir * acceleration * speed * Time.deltaTime);
            }

            else
            {
                if (!targetLockedOn)
                {                   
                    Run();
                    dir.y = 0;
                    targetRotation = Quaternion.LookRotation(dir, Vector3.up);
                    transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                    rb.MovePosition(rb.position + dir * acceleration * runSpeed * Time.deltaTime);
                }
            }
        }
    }
   
    public void LockEnemies()
    {
       
        if (enemiesToLock.Any())
        {
            if (!targetLockedOn)
            {
                targetLocked = enemiesToLock.First();
                mainCamera.GetComponent<CamController>().ChangeTarget(targetLocked);
                targetLockedOn = true;
                lockIndex = 0;
            }

            else
            {
                mainCamera.GetComponent<CamController>().StopLockedTarget();
                targetLocked = null;
                targetLockedOn = false;
            }
        }
    }

    public void ChangeTarget()
    {
        if(targetLockedOn && enemiesToLock.Count>=1)
        {
            lockIndex++;
            if (lockIndex > enemiesToLock.Count-1) lockIndex=0;
            targetLocked = enemiesToLock[lockIndex];
            mainCamera.GetComponent<CamController>().ChangeTarget(targetLocked);
        }
    }


    public void NormalAttack(Vector3 d)
    {
      
        dirToRotateAttack = mainCamera.transform.forward;

        if (isInCombat && !view.anim.GetBool("TakeSword2") && animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Blocked])
        {        
            countAnimAttack++;
            view.AwakeTrail();
            Attack();
            if (!makingDamage) StartCoroutine(TimeToDoDamage());
            StartCoroutine(AttackRotation());
            CombatState();
            attackDamage = attack1Damage;
        }
        

        if (canRollAttackTimer>0 && animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack])
        {
            attackDamage = attackRollDamage;
            RollAttackEvent();
            view.AwakeTrail();
            EndCombo();
            CombatState();
            StartCoroutine(ImpulseAttackAnimation());
            view.anim.SetBool("Roll", false);
            view.anim.SetBool("CanRollAttack", false);

        }

        if (!isDead && !onDefence && !view.anim.GetBool("SaveSword2") && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Roll]
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Back] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Left] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Right])
        {
            
            view.anim.SetLayerWeight(0, 1);
            view.anim.SetLayerWeight(1, 0);
            view.anim.SetBool("TakeSword2", false);

            if ((animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack3_End]))
            {
               view.EndDodge();
               view.AwakeTrail();
               countAnimAttack++;
               Attack();
               if (!makingDamage) StartCoroutine(TimeToDoDamage());
               timeImpulse = 0.07f;
               timeEndImpulse = 0.25f;
               StartCoroutine(ImpulseAttackAnimation());
               CombatState();
               StartCoroutine(AttackRotation());
               attackDamage = attack4Damage;
            }


            if (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack2_End])
            {
                view.EndDodge();
                countAnimAttack++;
                view.AwakeTrail();
                if (countAnimAttack > 3) countAnimAttack = 3;
                Attack();
                if (!makingDamage) StartCoroutine(TimeToDoDamage());
                timeImpulse = 0.15f;
                timeEndImpulse = 0.25f;
                StartCoroutine(ImpulseAttackAnimation());
                CombatState();
                StartCoroutine(AttackRotation());
                attackDamage = attack3Damage;
            }

            if (animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Attack1_End])
            {
                view.EndDodge();
                countAnimAttack++;
                view.AwakeTrail();
                if (countAnimAttack > 2) countAnimAttack = 2;
                Attack();
                if (!makingDamage) StartCoroutine(TimeToDoDamage());
                if (view.currentAttackAnimation == 2)
                {
                    timeImpulse = 0.1f;
                    timeEndImpulse = 0.35f;
                }
                StartCoroutine(ImpulseAttackAnimation());
                CombatState();
                StartCoroutine(AttackRotation());
                attackDamage = attack2Damage;
            }

            if ((animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.IdleCombat] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkW] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkS] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkD] 
                || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.WalkA] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Blocked] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Idle] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.Walk] 
                || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RunCombat] || animClipName == view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage])  && countAnimAttack==0)
            {
               
                if (isInCombat && !view.anim.GetBool("TakeSword2"))
                {                
                    view.EndDodge();
                    countAnimAttack++;
                    view.AwakeTrail();
                    Attack();                   
                    if(!makingDamage)StartCoroutine(TimeToDoDamage());           
                    StartCoroutine(AttackRotation());
                    attackDamage = attack1Damage;
                    CombatState();
                }
            }

            if (!isInCombat) CombatState();

            countAnimAttack = Mathf.Clamp(countAnimAttack, 0, 4);
            
            starChangeDirAttack = true;
        }
        if (!InActionAttack) InActionAttack = true;

    }

    public void UpdateLife (float val)
    {
        life += val;
        if (life > maxLife) life = maxLife;
        view.UpdateLifeBar(life / maxLife);
    }

    public void UpdateStamina(float val)
    {
        stamina += val;
        if (stamina > maxStamina) stamina = maxStamina;
        view.UpdateStaminaBar(stamina / maxStamina);
    }

    public void MakeDamage(string typeOfDamage)
    {

        if (onRoll) onRoll = false;

        var col = Physics.OverlapSphere(transform.position + transform.forward * 1.2f + new Vector3(0, 0.7f, 0), radiusAttack).Where(x => x.GetComponent<EnemyEntity>()).Select(x => x.GetComponent<EnemyEntity>()).Distinct().ToList();
        var col2 = Physics.OverlapSphere(transform.position + transform.forward * 0.5f + new Vector3(0, 0.7f, 0), radiusAttack).Where(x => x.GetComponent<EnemyEntity>()).Select(x => x.GetComponent<EnemyEntity>()).Distinct();
        var desMesh = Physics.OverlapSphere(transform.position + transform.forward * 1.2f + new Vector3(0, 0.7f, 0), radiusAttack).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>()).Distinct().ToList();
        var desMesh2 = Physics.OverlapSphere(transform.position + transform.forward * 0.5f + new Vector3(0, 0.7f, 0), radiusAttack).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>()).Distinct();

        col.AddRange(col2);

        var enemies = col.Distinct();

        desMesh.AddRange(desMesh2);

        var destructibleMesh = desMesh.Distinct();

        if (typeOfDamage == "Normal")
        {
            foreach (var item in enemies)
            {
                if(countAnimAttack<3) item.GetDamage(attackDamage, "Normal", 1);
                if(countAnimAttack<4 && countAnimAttack>2) item.GetDamage(attackDamage, "Normal", 2);
                if (countAnimAttack < 5 && countAnimAttack > 3) item.GetDamage(attackDamage, "Normal", 3);
                item.GetComponent<Rigidbody>().AddForce(-item.transform.forward * 2, ForceMode.Impulse);
                makingDamage = false;
            }
        }

        if(typeOfDamage =="Stune" && enemies.Count()>0)
        {
            if (!enemies.FirstOrDefault().isKnock)
            {
                enemies.FirstOrDefault().GetDamage(attackDamage, "Stune",0);
                enemies.FirstOrDefault().isStuned = true;
            }

            else
            {             
                if (countAnimAttack < 3) enemies.FirstOrDefault().GetDamage(attackDamage, "Normal",1);
                if (countAnimAttack < 4 && countAnimAttack > 2) enemies.FirstOrDefault().GetDamage(attackDamage, "Normal", 2);
                if (countAnimAttack < 5 && countAnimAttack > 3) enemies.FirstOrDefault().GetDamage(attackDamage, "Normal", 3);
            }

            if (enemies.FirstOrDefault().life > 0) enemies.FirstOrDefault().GetComponent<Rigidbody>().AddForce(-enemies.FirstOrDefault().transform.forward * 2, ForceMode.Impulse);

            var  restOfenemies = enemies.Skip(1);

            foreach (var item in restOfenemies)
            {
                if (countAnimAttack < 3) item.GetDamage(attackDamage, "Normal", 1);
                if (countAnimAttack < 4 && countAnimAttack > 2) item.GetDamage(attackDamage, "Normal", 2);
                if (countAnimAttack < 5 && countAnimAttack > 3) item.GetDamage(attackDamage, "Normal", 3);
                item.GetComponent<Rigidbody>().AddForce(-item.transform.forward * 2, ForceMode.Impulse);
                makingDamage = false;
            }
        }

        if (typeOfDamage == "Knock" && enemies.Count() > 0)
        {
            view.ShakeCameraDamage(1, 1, 0.5f);          
            enemies.FirstOrDefault().GetDamage(attackDamage, "Knock",0);
            enemies.FirstOrDefault().isKnock = true;
            enemies.FirstOrDefault().GetComponent<Rigidbody>().AddForce(-enemies.FirstOrDefault().transform.forward * 5, ForceMode.Impulse);
        }

        foreach (var item in destructibleMesh)
        {
            item.StartCoroutine(item.startDisolve());
            makingDamage = false;
        }

        makingDamage = false;
    }

    public void Power1Damage()
    {
        var col = Physics.OverlapSphere(transform.position, 2).Where(x => x.GetComponent<EnemyEntity>()).Select(x => x.GetComponent<EnemyEntity>()).Distinct();
        var desMesh = Physics.OverlapSphere(transform.position,2).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>());

        foreach (var item in desMesh)
        {
            item.StartCoroutine(item.startDisolve());
            makingDamage = false;
        }

        foreach (var item in col)
        {
            if (countAnimAttack < 3) item.GetDamage(damagePower2, "Normal", 1);
            if (countAnimAttack < 4 && countAnimAttack > 2) item.GetDamage(damagePower2, "Normal", 2);
            if (countAnimAttack < 5 && countAnimAttack > 3) item.GetDamage(attackDamage, "Normal", 3);
            if (item.GetComponent<ViewerE_Melee>())
            {
                item.GetComponent<ViewerE_Melee>().BackFromAttack();
                item.GetComponent<ModelE_Melee>().StopRetreat();
            }
            if(item.life>0)item.GetComponent<Rigidbody>().AddForce(-item.transform.forward * 8, ForceMode.Impulse);
            makingDamage = false;
        }

        makingDamage = false;
    }

    public void Defence()
    {
        StartCoroutine(OnDefenceCorrutine());

        if (onRoll) StopDefence();

        if (stamina >= 0 && !stuned && !onRoll && !defenceBroken && !onDamage  && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] &&  animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Back]
            && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Left] && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Right])
        {
            if (!view.anim.GetBool("CounterAttack")) DefenceEvent();
            else CounterAttackEvent();
            perfectParryTimer += Time.deltaTime;
            InAction = true;
            InActionAttack = true;
            onDefence = true;
            EndCombo();
        }
    }

    public void StopDefence()
    {
        perfectParryTimer = 0;
        StopDefenceEvent();
        InActionAttack = false;
        InAction = false;
        onDefence = false;
    }

    public void CombatState()
    {

        timeOnCombat = maxTimeOnCombat;
        if (!isInCombat)
        {
           view.TakeSword2();
        }
        isInCombat = true;
    }

  
    public void ActiveAttack()
    {
        InActionAttack = false;
        InAction = false;
    }

    public void FalseActiveAttack()
    {
        InActionAttack = true;
        InAction = true;
    }

    public void FalseOnDamage()
    {
        onDamage = false;
    }
  
    public void EndCombo()
    {
        countAnimAttack = 0;
        view.currentAttackAnimation = 0;
        view.anim.SetInteger("AttackAnim", 0);
        view.SleepTrail();
    }

    public void SaveSword()
    {
        timeOnCombat = 0;
        isInCombat = false;
        view.SaveSwordAnim2();
    }

    public void GetDamage(float damage, Transform enemy, bool isProyectile, bool heavyDamage, EnemyEntity e)
    {
        EndCombo();
        timeCdPower2 -= reduceTimePerHit;
        impulse = false;
        bool isBehind = false;
        timeEndImpulse = 0;
        timeImpulse = 0;
        makingDamage = false;
        Vector3 dir = transform.position - enemy.position;
        float angle = Vector3.Angle(dir, transform.forward);
        if (angle < 90) isBehind = true;


        if (!isBehind && !isProyectile && onDefence && !heavyDamage)
        {

            if (perfectParryTimer <= 0.3f)
            {
                snapTarget = e;
                mainCamera.GetComponent<CamController>().StartCoroutine(mainCamera.GetComponent<CamController>().KickCameraChange());
                rb.AddForce(-transform.forward , ForceMode.Impulse);
                CounterAttackEvent();
                if (!makingDamage) StartCoroutine(TimeToDoDamage());             
                attackDamage = 5;
                CombatState();
                view.ShakeCameraDamage(0.5f, 0.5f, 0.5f);
            }

            if(perfectParryTimer > 0.3f)
            {
                view.Blocked();
                view.ShakeCameraDamage(0.5f, 0.5f, 0.5f);
            }
          
            
        }

        if(heavyDamage && !onDefence && !invulnerable)
        {
            float dmg = damage - armor;
            UpdateLife(-dmg);
            timeToHeal = maxTimeToHeal;
            OnDamage();
            impulse = false;
        }

        if (heavyDamage && onDefence)
        {
            view.BlockedFail();
            StopDefence();
            StartCoroutine(DefenceBroken());
            view.defenceColdwon.fillAmount = 1;
            impulse = false;
            view.ShakeCameraDamage(1,1,0.5f);
        }

        if ((!onDefence || (onDefence && isBehind) || isProyectile) && !heavyDamage && !invulnerable)
        {
            UpdateLife(-damage);
            timeToHeal = maxTimeToHeal;
            impulse = false;

            if (life > 0 && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack]
                        && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Back]
                        && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Left]
                        && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.Dodge_Right]
                        && animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage]) OnDamage();
                    
        }

        if (life <= 0 && !isDead)
        {
            fadeTimer = 0;
            Dead();
            isDead = true;
            StartCoroutine(view.YouDied());
            timeOnCombat = 0;
        }

        StartCoroutine(OnDamageCorrutine());
    }

    public EnemyPointer PointerFactory()
    {       
        EnemyPointer p = Instantiate(pointerPrefab);
        p.mat = p.GetComponent<MeshRenderer>().material;
        p.transform.position = pointerParent.position + new Vector3(0,amountOfPointers,0);
        p.myPos = amountOfPointers;
        p.myParent2 = pointerParent2;
        p.transform.SetParent(pointerParent);
        p.myParent = pointerParent;
        amountOfPointers += 0.01f;
        return p;
    }

    public void ReturnPointer(EnemyPointer p)
    {
        pointerPool.DisablePoolObject(p);
    }


    public void OnCollisionEnter(Collision c)
    {
       
    }

    void OnTriggerEnter(Collider c)
    {

        if (c.gameObject.layer == LayerMask.NameToLayer("WIN"))
            StartCoroutine(view.YouWin());
    }


    public void StartInteraction()
    {
        Ray ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 1.5f))
        {
            var comp = hit.transform.GetComponent<Interactable>();
            if (comp)
                comp.Interaction();
        }
    }

    public void OnDrawGizmos()
    {

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position + transform.forward * 0.5f + new Vector3(0,0.7f,0), radiusAttack);
        Gizmos.DrawWireSphere(transform.position + transform.forward *1.2f + new Vector3(0, 0.7f, 0), radiusAttack);

        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position + new Vector3(0 ,0.3f, 0), distanceAggressiveNodes);

        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position + new Vector3(0, 0.3f, 0), distanceNon_AggressiveNodes);
    }

    public void WraperAction()
    {
        if (!onRoll && !isDead && !InActionAttack && !onDamage) InAction = false;
        else InAction = true;
    }
}

