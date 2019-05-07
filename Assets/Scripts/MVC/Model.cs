using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class Model : MonoBehaviour
{
    public Transform attackPivot;
    public Viewer view;

    public PowerManager powerManager;
    public Powers prefabPower;
    public Pool<Powers> powerPool;

    public float radiusAttack;
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
    bool makingDamage;

    [Header("Player Powers")]

    public float timeCdPower2;
    public float damagePower2;
    public float reduceTimePerHit;


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

    public Skills mySkills;
    public bool isIdle;
    public bool onPowerState;
    public bool isRuning;
    public bool isInCombat;
    public bool isDead;
    public bool onDefence;
    public bool onRoll;
    public bool saveSword;
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
    public EnemyClass currentEnemy;

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
  //  public Action RollCameraEvent;
    public Action StreakEvent;
    public Action RollAttackEvent;

    public Transform closestEnemy;
    public LayerMask enemyLM;
    bool checking;
    bool delayForDash;
    bool timeToRotate;
    Vector3 dirToDahs;
    public float impulseForce;

    float timeImpulse;
    float timeEndImpulse;
    public float internCdPower2;
    public string animClipName;

    bool preAttack1;
    bool preAttack2;
    bool preAttack3;
    bool preAttack4;

    public Transform test;

    [HideInInspector]
    public float fadeTimer;

    public IEnumerator PowerDelayImpulse(float timeStart, float timeEnd, float time1, float time2)
    {
        yield return new WaitForSeconds(timeStart + timeEnd);
        timeImpulse = time1;
        timeEndImpulse = time2;
    }

    public IEnumerator GetHeavyDamage()
    {
        stuned = true;
        yield return new WaitForSeconds(2);
        stuned = false;
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
    }

    public IEnumerator OnDamageDelay()
    {
        yield return new WaitForSeconds(0.5f);
        onDamage = false;
    }

    public IEnumerator CombatDelayState()
    {
        yield return new WaitForSeconds(0.4f);
        CombatState();
    }

    public enum PotionName { Health, Stamina, Extra_Health, Costless_Hit, Mana };

    void Start()
    {
        timeOnCombat = -1;
        rb = GetComponent<Rigidbody>();
        powerManager = FindObjectOfType<PowerManager>();
        powerPool = new Pool<Powers>(10, PowersFactory, Powers.InitializePower, Powers.DisposePower, true);
        mySkills = new Skills();
       // mainCamera = Camera.main.transform;

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
        if (cdPower2)
        {
            timeCdPower2 -= Time.deltaTime;
            if (timeCdPower2 <= 0)
            {
                cdPower2 = false;      
            }
        }

        if (timeCdPower2 <= 0) timeCdPower2 = internCdPower2;

        timeToRotateAttack -= Time.deltaTime;

        if(timeToRotateAttack>0)
        {
            dirToRotateAttack.y = 0;
            Quaternion targetRotation;
            targetRotation = Quaternion.LookRotation(dirToRotateAttack, Vector3.up);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
        }

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

        animClipName = view.anim.GetCurrentAnimatorClipInfo(0)[0].clip.name;
      
        TimeToDoDamage();
        ImpulseAttackAnimation();
        RollImpulse();

        if (onDefence)
        {
            var defenceDir = mainCamera.transform.forward;
            defenceDir.y = 0;
            Quaternion targetRotation;
            targetRotation = Quaternion.LookRotation(defenceDir, Vector3.up);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
        }

        if(stamina<5)
        {
            StopDefence();
            view.NoDefence();
        }

        if (fadeTimer < view.fadeTime) fadeTimer += Time.deltaTime;
        else view.startFade.enabled = false;
    }

    public void TimeToDoDamage()
    {
        if (makingDamage && animClipName == "Attack4N-DAMAGE") MakeDamage();
        if (makingDamage && animClipName == "Attack3N-DAMAGE") MakeDamage();
        if (makingDamage && animClipName == "Attack2N-DAMAGE") MakeDamage();
        if (makingDamage && animClipName == "Attack1N-DAMAGE") MakeDamage();
        if (makingDamage && animClipName == "RollAttack-DAMAGE") MakeDamage();
    }

    public void ImpulseAttackAnimation()
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
                if (countAnimAttack == 0) transform.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * (impulseForce + 1) * Time.deltaTime, 2);
            }
        }
    }

    public void Roll(Vector3 dir)
    {
        if (stamina - rollStamina >= 0 && !view.anim.GetBool("Roll") && !onRoll)
        {
            RollEvent();
           // RollCameraEvent();
            stamina -= rollStamina;
            view.UpdateStaminaBar(stamina / maxStamina);           
            onRoll = true;
            dirToDahs = dir;
            dirToDahs.y = 0;
            makingDamage = false;
            impulse = false;
            timeToRoll = 0.45f;
            lastPosition = transform.position;
        }
    } 

    public void CombatParameters()
    {
        if (countAnimAttack == 0 && !onPowerState) view.SleepTrail();

        timeOnCombat -= Time.deltaTime;
        if (timeOnCombat > 0)
        {
            view.anim.SetBool("IdleCombat", true);
        }

        if (timeOnCombat <= 0) timeOnCombat = 0;

        if (timeOnCombat <= 0 && isInCombat)
        {
            view.SaveSwordAnim2();        
            isInCombat = false;
            saveSword = false;
        }


        timeToHeal -= Time.deltaTime;

        if (timeToHeal <= 0 && life > 0)
        {
            life += lifeRecoveredForSec * Time.deltaTime;
            if (isInCombat) life += lifeRecoveredForSecInCombat * Time.deltaTime;
            else life += lifeRecoveredForSec * Time.deltaTime;

            if (life > maxLife) life = maxLife;
            view.UpdateLifeBar(life / maxLife);
        }
    }

    public void RollImpulse()
    {
        if (onRoll)
        {
            timeToRoll -= Time.deltaTime;

            transform.forward = dirToDahs;

            transform.position += transform.forward * 6 * Time.deltaTime;

            if (timeToRoll <= 0)
            {
                var dir = mainCamera.forward;
                dir.y = 0;
                transform.forward = dir;
                onRoll = false;
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
        if (!cdPower2 && !onPowerState && !onDamage && !isDead && !onRoll && stamina - powerStamina >= 0 && isInCombat && !onDefence)
        {
            timeCdPower2 = internCdPower2;
            stamina -= powerStamina;
            view.UpdateStaminaBar(stamina / maxStamina);
            StreakEvent();
            CombatState();
            timeImpulse = 0.4f;
            timeEndImpulse = 0.2f;
            StartCoroutine(PowerDelayImpulse(0.4f, 0.2f, 0.1f, 0.2f));
            StartCoroutine(PowerColdown(timeCdPower2, 2));            
        }
    }

    public void CastPower1()
    {
        if (!cdPower1 && !onPowerState && !onDamage && !isDead && !onRoll && stamina - powerStamina >= 0)
        {
            stamina -= powerStamina;
            view.UpdateStaminaBar(stamina / maxStamina);

            Powers newPower = powerPool.GetObjectFromPool();
            newPower.myCaller = transform;
            powerManager.SetIPower(1, newPower, this);
            RotateAttack();
            onPowerState = true;
        }
    }

    public void CastPower3()
    {
        if (!cdPower3 && !onPowerState && !onDamage && !isDead && !onRoll && stamina - powerStamina >= 0)
        {
            stamina -= powerStamina;
            view.UpdateStaminaBar(stamina / maxStamina);

            CombatState();
            Uppercut();
        }
    }

    public void CastPower4()
    {
        if (!cdPower4 && !onPowerState && !onDamage && !isDead && !onRoll  && countAnimAttack == 0 && stamina - powerStamina >= 0)
        {
            Powers newPower = powerPool.GetObjectFromPool();
            newPower.myCaller = transform;
            powerManager.SetIPower(3, newPower, this);
            onPowerState = true;
        }
    }

    public void Movement(Vector3 dir)
    {
        if (isRuning)
        {
            stamina -= runStamina * Time.deltaTime;
            view.UpdateStaminaBar(stamina / maxStamina);
        }

        acceleration += 3f * Time.deltaTime;
        if (acceleration > maxAcceleration) acceleration = maxAcceleration;

        if (!InAction && !onDamage && countAnimAttack == 0 && !onRoll)
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

    public void CombatMovement(Vector3 dir, bool key, bool rotate)
    {
        if (isRuning)
        {
            stamina -= runStamina * Time.deltaTime;
            view.UpdateStaminaBar(stamina / maxStamina);
        }

        acceleration += 3f * Time.deltaTime;
        if (acceleration > maxAcceleration) acceleration = maxAcceleration;

        if (!InAction && !onDamage && countAnimAttack == 0 && !view.anim.GetBool("RollAttack") && !onRoll && animClipName != "GetDamage1" 
                                                                      && animClipName != "GetDamage2" 
                                                                      && animClipName != "GetDamage3")
        {
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

                if(rotate)
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
                Run();
                dir.y = 0;
                targetRotation = Quaternion.LookRotation(dir, Vector3.up);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                rb.MovePosition(rb.position + dir * acceleration * runSpeed * Time.deltaTime);
            }
        }
    }
   
    public void Idle()
    {
        isIdle = true;
    }

    public void NoIdle()
    {
        isIdle = false;
    }



    public void NormalAttack(Vector3 d)
    {
        dirToRotateAttack = d;

        if(onRoll)
        {
            makingDamage = true;
            attackDamage = attackRollDamage;
            RollAttackEvent();
            EndCombo();
            onRoll = false;
            view.BackRollAnim();
            var dir = mainCamera.transform.forward;
            dir.y = 0;
            transform.forward = dir;
        }

        if (!isDead && stamina - attackStamina >= 0 && !onRoll && !onDefence && !view.anim.GetBool("SaveSword2"))
        {

            view.anim.SetLayerWeight(0, 1);
            view.anim.SetLayerWeight(1, 0);
            view.anim.SetBool("TakeSword2", false);

            if ((animClipName == "Attack3N-FINISH" && !preAttack4))
            {
               view.AwakeTrail();
               countAnimAttack++;
               Attack();
               makingDamage = true;
               timeImpulse = 0.04f;
               timeEndImpulse = 0.2f;
               preAttack4 = true;
               stamina -= attackStamina + 3;
               view.UpdateStaminaBar(stamina / maxStamina);
               CombatState();
               timeToRotateAttack = 0.3f;
               attackDamage = attack4Damage;
            }


            if (animClipName == "Attack2N-FINISH" && !preAttack3)
            {
                countAnimAttack++;
                view.AwakeTrail();
                if (countAnimAttack > 3) countAnimAttack = 3;
                Attack();
                makingDamage = true;
                timeImpulse = 0.1f;
                timeEndImpulse = 0.2f;
                preAttack3 = true;
                stamina -= attackStamina;
                view.UpdateStaminaBar(stamina / maxStamina);
                CombatState();
                timeToRotateAttack = 0.3f;
                attackDamage = attack3Damage;
            }

            if (animClipName == "Attack1N-FINISH" && !preAttack2)
            {
                countAnimAttack++;
                view.AwakeTrail();
                if (countAnimAttack > 2) countAnimAttack = 2;
                Attack();
                makingDamage = true;
                timeImpulse = 0.01f;
                timeEndImpulse = 0.3f;
                preAttack2 = true;
                stamina -= attackStamina;
                view.UpdateStaminaBar(stamina / maxStamina);
                CombatState();
                timeToRotateAttack = 0.3f;
                attackDamage = attack2Damage;
            }

            if ((animClipName == "IdleCombat-new" || animClipName == "WalkW" || animClipName == "WalkS" || animClipName == "WalkD" || animClipName == "WalkA" 
                || animClipName == "Idel V2.0" || animClipName == "Walk03" || animClipName == "Run03" || animClipName == "Run Whit Sword V3.2") && !preAttack1 && countAnimAttack==0)
            {
                if (isInCombat && !view.anim.GetBool("TakeSword2"))
                {                   
                    countAnimAttack++;
                    view.AwakeTrail();
                    Attack();
                    makingDamage = true;
                    preAttack1 = true;
                    stamina -= attackStamina;
                    view.UpdateStaminaBar(stamina / maxStamina);
                    timeToRotateAttack = 0.3f;
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

    

    public void MakeDamage()
    {      
        var col = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<EnemyEntity>()).Select(x => x.GetComponent<EnemyEntity>());
        var desMesh = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>());

        if (col.Count() > 0)
        {
            if(countAnimAttack<=3) view.ShakeCameraDamage(0.5f);
        }

        foreach (var item in col)
        {
            item.GetDamage(attackDamage);
            item.GetComponent<Rigidbody>().AddForce(-item.transform.forward * 2, ForceMode.Impulse);
            makingDamage = false;
        }

        foreach (var item in desMesh)
        {
            item.StartCoroutine(item.startDisolve());
            makingDamage = false;
        }
    }

    public void Power1Damage()
    {
        var col = Physics.OverlapSphere(transform.position, 2).Where(x => x.GetComponent<EnemyEntity>()).Select(x => x.GetComponent<EnemyEntity>());
        var desMesh = Physics.OverlapSphere(transform.position,2).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>());

        foreach (var item in desMesh)
        {
            item.StartCoroutine(item.startDisolve());
            makingDamage = false;
        }

        foreach (var item in col)
        {
            item.GetDamage(damagePower2);
            if (item.GetComponent<ViewerE_Melee>())
            {
                item.GetComponent<ViewerE_Melee>().BackFromAttack();
                item.GetComponent<ModelE_Melee>().StopRetreat();
            }
            item.GetComponent<Rigidbody>().AddForce(-item.transform.forward * 8, ForceMode.Impulse);
            makingDamage = false;
        }
    }

    public void Defence()
    {
        if (stamina >= 0 && !stuned)
        {
            InAction = true;
            InActionAttack = true;
            onDefence = true;
        }
    }

    public void StopDefence()
    {
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
        preAttack1 = false;
        preAttack2 = false;
        preAttack3 = false;
        preAttack4 = false;
    }

    public void SaveSword()
    {
        timeOnCombat = 0;
        isInCombat = false;
        view.SaveSwordAnim2();
    }

    public void GetDamage(float damage, Transform enemy, bool isProyectile, bool heavyDamage)
    {
        timeCdPower2 -= reduceTimePerHit;
        impulse = false;
        if (onRoll) view.ShakeCameraDamage(2);
        bool isBehind = false;
        StartCoroutine(OnDamageDelay());
        timeEndImpulse = 0;
        timeImpulse = 0;
        makingDamage = false;
        Vector3 dir = transform.position - enemy.position;
        float angle = Vector3.Angle(dir, transform.forward);
        if (angle < 90) isBehind = true;
        if (!isBehind && !isProyectile && onDefence && !heavyDamage)
        {
            stamina -= blockStamina;
            view.UpdateStaminaBar(stamina / maxStamina);
            BlockEvent();
        }

        if(heavyDamage)
        {
            float dmg = damage - armor;
            life -= dmg;
            timeToHeal = maxTimeToHeal;
            view.UpdateLifeBar(life / maxLife);
            impulse = false;
        }

        if (!onDefence || (onDefence && isBehind) || isProyectile)
        {

            if (armor >= damage)
            {
                armor -= damage;
                view.UpdateArmorBar(armor / maxArmor);
            }
            else
            {
                float dmg = damage - armor;
                armor = 0;
                view.UpdateArmorBar(armor / maxArmor);
                life -= dmg;
                timeToHeal = maxTimeToHeal;
                view.UpdateLifeBar(life / maxLife);
                impulse = false;
            }

            if (!onPowerState)
            {
                onDamage = true;
            }
            if (life > 0 && !onPowerState && !onRoll) OnDamage();
            
            if(life<=0)
            {
                if (!dieOnce)
                {
                    Dead();
                    isDead = true;
                    StartCoroutine(view.YouDied());
                    dieOnce = true;
                }
            }       
        }
    }


    public Powers PowersFactory()
    {
        Powers newPower = Instantiate(prefabPower);
        newPower.transform.SetParent(powerManager.transform);
        newPower.myCaller = transform;
        return newPower;
    }

    public void ReturnBulletToPool(Powers powers)
    {
        powerPool.DisablePoolObject(powers);
    }

    public void OnCollisionEnter(Collision c)
    {
       
    }

    void OnTriggerEnter(Collider c)
    {
        if (c.gameObject.layer == 14)
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
        Gizmos.DrawWireSphere(attackPivot.position, radiusAttack);
    }

    public void WraperAction()
    {
        if (!onRoll && !isDead && !InActionAttack && !onDamage) InAction = false;
        else InAction = true;
    }
}

