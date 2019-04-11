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
    public float life;
    public float maxLife;
    public float speed;
    public float runSpeed;
    public float acceleration;
    public float maxAcceleration;
    public float timeOnCombat;
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
    public float dashStamina;
    public float recoveryStamina;
    public float timeAnimCombat;


    public int[] potions = new int[5];
    public IPotionEffect currentPotionEffect;
    IPotionEffect[] potionEffects = new IPotionEffect[5];

    public int countAnimAttack;
    public Collider enemy;

    Vector3 lastPosition;

    public int stocadaAmount;

    public Skills mySkills;
    public bool isIdle;
    public bool onAir;
    public bool stocadaState;
    public bool onPowerState;
    public bool jumpAttackWarriorState;
    public bool chargeTankeState;
    public bool isRuning;
    public bool isAnimatedMove;
    public bool isInCombat;
    public bool isDead;
    public bool onDefence;
    public bool onRoll;
    public bool onRollCombat;
    public bool biz;
    public bool sleepAnim;
    public bool saveSword;
    bool impulse;
    bool starChangeDirAttack;

    bool cdPower1;
    bool cdPower2;
    bool cdPower3;
    bool cdPower4;
    public bool InAction;
    public bool InActionAttack;
    bool WraperInAction;

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
    public Action RollCameraEvent;

    public Transform closestEnemy;
    public LayerMask enemyLM;
    bool checking;
    bool delayForDash;
    bool timeToRotate;
    Vector3 dirToDahs;
    public float impulseForce;

    float timeDamage;
    float timeEndDamage;

    float timeImpulse;
    float timeEndImpulse;

    string animClipName;

    bool preAttack1;
    bool preAttack2;
    bool preAttack3;
    bool preAttack4;

    [HideInInspector]
    public float fadeTimer;

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

    public IEnumerator InActionDelay(float cdTime)
    {
        WraperInAction = true;
        yield return new WaitForSeconds(cdTime);
        WraperInAction = false;
        onPowerState = false;
    }

    public IEnumerator ActionDelay(Action power)
    {
        yield return new WaitForSeconds(1.5f);
        RotateAttack();
        power();
    }

    public IEnumerator RotateCorrutine()
    {
        yield return new WaitForSeconds(1f);
        timeToRotate = false;
    }

    public IEnumerator PowerDelay(float time)
    {
        yield return new WaitForSeconds(time);
        Powers newPower = powerPool.GetObjectFromPool();
        newPower.myCaller = transform;
        powerManager.SetIPower(2, newPower, this);

        onAir = true;
        onPowerState = true;
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

    public enum PotionName { Health, Extra_Health, Stamina, Costless_Hit, Mana };

    void Start()
    {
        timeOnCombat = -1;
        rb = GetComponent<Rigidbody>();
        powerManager = FindObjectOfType<PowerManager>();
        powerPool = new Pool<Powers>(10, PowersFactory, Powers.InitializePower, Powers.DisposePower, true);
        mySkills = new Skills();

        for (int i = 0; i < 5; i++)
            view.UpdatePotions(i);
        potionEffects[1] = new ExtraHealth(this, 60);
        currentPotionEffect = null;
        checking = false;
        fadeTimer = 0;
    }

    void Update()
    {

      

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

        WraperAction();
        if (life <= 0)
        {
            Dead();
            isDead = true;
        }

        if (!isRuning && !onPowerState && !onDamage && !isDead && !onRoll && !onDefence)
        {
            float prevS = stamina;

            if(isInCombat) stamina += recoveryStamina * Time.deltaTime;

            else stamina += recoveryStamina * Time.deltaTime * 2;

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

        if (onRoll)
        {
            if (isInCombat && timeToRotate)
            {
                if (onDamage)
                {
                    onRoll = false;
                    onRollCombat = false;
                }
                sleepAnim = false;
                transform.forward = dirToDahs;
                Quaternion targetRotation;
                targetRotation = Quaternion.LookRotation(dirToDahs, Vector3.up);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 7 * Time.deltaTime);
                if (transform.forward == dirToDahs) timeToRotate = false;
            }
            else if (isInCombat && !timeToRotate && onRollCombat)
            {
                if (onDamage)
                {
                    onRoll = false;
                    onRollCombat = false;
                }
                sleepAnim = false;
                rb.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * Time.deltaTime * 6, 2);
            }

            if (!isInCombat)
            {
                if (onDamage) onRoll = false;
                sleepAnim = false;
                rb.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * Time.deltaTime * 6, 2);
            }
        }

        timeDamage -= Time.deltaTime;

        if (timeDamage < 0)
        {
            timeEndDamage -= Time.deltaTime;
            if (timeEndDamage > 0) MakeDamage();
        }

        timeImpulse -= Time.deltaTime;

        if (timeImpulse < 0)
        {
            timeEndImpulse -= Time.deltaTime;
            if(timeEndImpulse>0)
            {
                if (onDamage) timeEndImpulse = 0;
                rb.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * impulseForce * Time.deltaTime, 2);
            }
        }   

        if(stamina<5)
        {
            StopDefence();
            view.NoDefence();
        }

        if (fadeTimer < view.fadeTime) fadeTimer += Time.deltaTime;
        else view.startFade.enabled = false;
    }

    public void Roll(Vector3 dir)
    {
        if (!onRoll && stamina - dashStamina >= 0 && !view.anim.GetBool("Roll"))
        {
            RollCameraEvent();
            stamina -= dashStamina;
            view.UpdateStaminaBar(stamina / maxStamina);
            if (isInCombat)
            {
                onRoll = true;
                RollEvent();
                dirToDahs = dir;
                timeToRotate = true;
            }
            else RollEvent();

            lastPosition = transform.position;
        }
    }

    public void StartRoll()
    {
        timeDamage = 0;
        timeEndDamage = 0;
        impulse = false;
        onRoll = true;
        if (isInCombat) onRollCombat = true;
    }

    public void StopRoll()
    {
        onRoll = false;
        if (isInCombat) onRollCombat = false;
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
            else
                if (i == (int)PotionName.Mana)
                {
                    isFull = mana == maxMana;
                    if (!isFull)
                        potionEffects[i] = new Mana(this, mana, maxMana);
                }

        if (!isFull)
        {
            potions[i]--;
            view.UpdatePotions(i);
            currentPotionEffect = potionEffects[i];
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
            powerManager.SetIPower(0, newPower, this);
            Estocada();
            onPowerState = true;
        }
    }

    public void CastPower2()
    {
        if (!cdPower2 && !onPowerState && !onDamage && !isDead && !onRoll && stamina - powerStamina >= 0)
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
            StartCoroutine(PowerDelay(0.5f));
        }
    }

    public void CastPower4()
    {
        if (!cdPower4 && !onPowerState && !onDamage && !isDead && !onRoll && !onAir && countAnimAttack == 0 && stamina - powerStamina >= 0)
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

        if (!InAction && !onDamage && countAnimAttack == 0 && !onRoll)
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

    public void FallDelay()
    {
        StartCoroutine(InActionDelay(0.7f));
    }

    public void Idle()
    {
        isIdle = true;
    }

    public void NoIdle()
    {
        isIdle = false;
    }

    public void NormalAttack()
    {
        if (!isDead && stamina - attackStamina >= 0 && !onRoll && !onRollCombat)
        {      
            if (countAnimAttack == 0 && !preAttack1)
            {
                countAnimAttack++;
                view.AwakeTrail();
                Attack();
                StartCoroutine(CombatDelayState());
                timeDamage = 0.066667f;
                timeEndDamage = 0.1f;
                timeImpulse = 0.08f;
                timeEndImpulse = 0.1f;
                preAttack1 = true;
            }

          
            if (animClipName == "Attack1-Finish" && !preAttack2)
            {
                countAnimAttack++;
                view.AwakeTrail();
                if (countAnimAttack > 2) countAnimAttack = 2;
                Attack();
                timeDamage = 0.1f;
                timeEndDamage = 0.12f;
                timeImpulse = 0.01f;
                timeEndImpulse = 0.3f;
                preAttack2 = true;
            }

            if (animClipName == "Attack2-Finish" && !preAttack3)
            {
               countAnimAttack++;
               view.AwakeTrail();
               if (countAnimAttack > 3) countAnimAttack = 3;
               Attack();
               timeDamage = 0.066667f;
               timeEndDamage = 0.1f;
               timeImpulse = 0.01f;
               timeEndImpulse = 0.2f;
               preAttack3 = true;
            }

            if ((animClipName == "Attack3-END" && !preAttack4) || (animClipName == "Attack3-DAMAGE" && !preAttack4))
            {
               view.AwakeTrail();
               countAnimAttack++;
               Attack();
               timeDamage = 0.066667f;
               timeEndDamage = 0.1f;
               timeImpulse = 0.01f;
               timeEndImpulse = 0.2f;
               preAttack4 = true;
            }
            

            countAnimAttack = Mathf.Clamp(countAnimAttack, 0, 4);
            
            starChangeDirAttack = true;
        }
        if (!InActionAttack) InActionAttack = true;

    }

    

    public void MakeDamage()
    {
       
        var col = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<EnemyEntity>()).Select(x => x.GetComponent<EnemyEntity>());
        var desMesh = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>()); ;
        foreach (var item in col)
        {
            view.StartCoroutine(view.SlowSpeed());
            item.GetDamage(10);
            item.GetComponent<Rigidbody>().AddForce(-item.transform.forward * 2, ForceMode.Impulse);
            timeDamage = 0;
            timeEndDamage = 0;
        }

        foreach (var item in desMesh)
        {
            item.StartCoroutine(item.startDisolve());
            timeDamage = 0;
        }
    }

    public void Defence()
    {
        if (stamina >= 0)
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
        timeOnCombat = 10;
        view.anim.SetBool("IdleCombat", true);
        view.anim.SetBool("Idle", true);
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

    public void GetDamage(float damage, Transform enemy, bool isProyectile)
    {
        impulse = false;
        onRoll = false;
        onRollCombat = false;
        view.anim.SetBool("Roll", false);
        rb.velocity = Vector3.zero;
        sleepAnim = false;
        bool isBehind = false;
        StartCoroutine(OnDamageDelay());
        timeEndImpulse = 0;
        timeImpulse = 0;
        timeDamage = 0;
        timeEndDamage = 0;
        Vector3 dir = transform.position - enemy.position;
        float angle = Vector3.Angle(dir, transform.forward);
        if (angle < 90) isBehind = true;
        if (!isBehind && !isProyectile && onDefence)
        {
            stamina -= 10;
            view.UpdateStaminaBar(stamina / maxStamina);
            BlockEvent();
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
                view.UpdateLifeBar(life / maxLife);
                sleepAnim = false;
                impulse = false;
                onRoll = false;
                rb.velocity = Vector3.zero;

            }

            if (!onPowerState)
            {

                rb.velocity = Vector3.zero;
                onDamage = true;
            }
            if (life > 0) OnDamage();
            else
            {

                Dead();
                isDead = true;
                StartCoroutine(view.YouDied());
            }

            onRoll = false;
            onRollCombat = false;
        }

        onRoll = false;
        onRollCombat = false;
    }

    public IEnumerator CheckClosestEnemy()
    {
        if (!checking)
        {
            checking = true;
            Collider[] col = Physics.OverlapSphere(transform.position, 20, enemyLM);
            float d = 9999999;
            bool picked = false;

            foreach (var i in col)
            {
                float dist = Vector3.Distance(transform.position, i.transform.position);
                float angle = Vector3.Angle(transform.forward, i.transform.position);
                if (dist < d)
                {
                    closestEnemy = i.transform;
                    picked = true;
                    d = dist;
                }
                else
                {
                    if (!picked)
                        closestEnemy = null;
                }
            }
            yield return new WaitForSeconds(0.5f);
            checking = false;
        }
        yield return null;
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
        if (onAir)
        {
            Fall();
            onAir = false;
        }
        if ((stocadaState && c.gameObject.GetComponent<EnemyClass>()) ||
            (stocadaState && c.gameObject.layer == LayerMask.NameToLayer("Obstacles")))
        {
            enemy = c.gameObject.GetComponent<Collider>();
            powerManager.currentPowerAction.Ipower2();
            stocadaAmount++;
            if (stocadaAmount > powerManager.amountOfTimes)
            {
                powerManager.constancepower = false;
                powerManager.currentPowerAction = null;
                stocadaState = false;
                onPowerState = false;
                stocadaAmount = 0;
                powerManager.amountOfTimes = 0;
                view.BackEstocada();
            }
        }

        if (jumpAttackWarriorState)
        {
            powerManager.currentPowerAction.Ipower2();
            powerManager.constancepower = false;
            powerManager.currentPowerAction = null;
            onAir = false;
            onPowerState = false;
        }

        if (chargeTankeState)
        {
            if (c.gameObject.GetComponent(typeof(EnemyClass))) currentEnemy = c.gameObject.GetComponent<EnemyClass>();
            powerManager.currentPowerAction.Ipower2();
        }

        if (c.gameObject.GetComponent<Platform>())
            currentPlatform = c.gameObject.GetComponent<Platform>();
    }

    void OnTriggerEnter(Collider c)
    {
        if (c.gameObject.layer == 10)
            StartCoroutine(view.YouWin());

        if (c.gameObject.layer == LayerMask.NameToLayer("Life"))
        {
            if (life < maxLife) life += 30;
            else life = maxLife;
            view.UpdateLifeBar(life / maxLife);
            var col = Physics.OverlapSphere(c.transform.position, 1);
            foreach (var i in col)
                if (i.transform.parent)
                    if (i.transform.parent.name == "Chest")
                        Destroy(i.transform.parent.gameObject);
            Destroy(c.gameObject);
        }
    }

    public void StopJumpAttack()
    {
        jumpAttackWarriorState = false;
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


    public IEnumerator PlatformJump()
    {
        if (currentPlatform)
        {
            Vector3 p1 = currentPlatform.transform.position;
            Vector3 p3 = currentPlatform.otherPlatform.position;
            Vector3 p2 = Vector3.Lerp(p1, p3, 0.5f);
            p2.y = (p1.y > p3.y ? p1.y : p3.y) + 15;
            float t = 0;
            isPlatformJumping = true;

            while (currentPlatform != null)
            {
                t += Time.deltaTime;
                rb.transform.position = Vector3.Lerp(Vector3.Lerp(p1, p2, t), Vector3.Lerp(p2, p3, t), t);

                if (transform.position.x == p3.x && transform.position.z == p3.z)
                {
                    currentPlatform = null;
                    isPlatformJumping = false;
                }
                yield return new WaitForFixedUpdate();
            }
        }
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(attackPivot.position, radiusAttack);
    }

    public void WraperAction()
    {
        // if (stocadaState || WraperInAction || chargeTankeState || jumpAttackWarriorState || InActionAttack || onAir || isDead || onDamage || onRoll) InAction = false;
        //else InAction = true;
        if (!onRoll && !isDead && !InActionAttack && !onDamage) InAction = false;
        else InAction = true;
    }
}

