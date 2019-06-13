using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Linq;

public class Viewer : MonoBehaviour
{

    public Model model;
    public Controller controller;
    public Animator anim;
    bool turn;
    bool melleCombo1;
    bool melleCombo2;
    bool melleCombo3;
    public CamShake camShake;
    public Transform head;
    Quaternion headBaseRot;
    public ParticleSystem blood;
    public ParticleSystem healParticles;
    public ParticleSystem antisipationRing;

    public Image power1;
    public Image power2;
    public Image power3;
    public Image power4;
    public Image defenceActive;
    public Image defenceColdwon;

    public GameObject youDied;
    public GameObject youWin;
    public GameObject phParticles;
    public GameObject trail;

    public Image lifeBar;
    public Image staminaBar;
    public Image manaBar;
    public Image armor;

    public Image[] potions;
    public Text potionTimer;

    public List<GameObject> particlesSowrd;

    public int currentAttackAnimation;

    public float preAttacktime;
    public string animClipName;

    float timeToSaveSword;

    CamController cam;
    public GameObject pauseMenu;

    bool slowSpeed;

    public enum AnimPlayerNames {Dead, Attack1_Pre, Attack1_Damage, Attack1_End, Attack2_Pre, Attack2_Damage, Attack2_End, Attack3_Pre, Attack3_Damage, Attack3_End, Attack4_Pre, Attack4_Damage, Attack4_End,
                                 Parry1, Parry2, Parry3, Parry4, BackAttack2, TurnAttack_Pre, TurnAttack_Damage, TurnAttack_End, TakeDamage1, TakeDamage2, TakeDamage3, Defence, Blocked, FailDefence, Kick, IdleCombat, WalkW, WalkS,
                                 WalkD, WalkA, RunCombat, Run, Walk, Idle, Roll, RollAttack, RollEstocada_Damage, Dodge_Left, Dodge_Back, Dodge_Right};

    public Dictionary<AnimPlayerNames, string> AnimDictionary = new Dictionary<AnimPlayerNames, string>();

    public RawImage startFade;
    [Header("Time of the initial fade from black:")]
    public float fadeTime;

    public GameObject smashParticle;

    public IEnumerator DestroyParticles(GameObject p)
    {
        yield return new WaitForSeconds(0.5f);
        Destroy(p);
    }

    public IEnumerator SaveSwordAnim()
    {
        yield return new WaitForSeconds(0.5f);
        anim.SetLayerWeight(1, 0);
    }

    public IEnumerator TakeSwordAnim()
    {
        yield return new WaitForSeconds(0.3f);
        anim.SetLayerWeight(1, 0);
    }

    public IEnumerator SmashParticleEvent()
    {
        smashParticle.SetActive(false);
        yield return new WaitForSeconds(0.7f);
        trail.SetActive(false);

        if (animClipName == AnimDictionary[AnimPlayerNames.Attack4_Damage] || animClipName == AnimDictionary[AnimPlayerNames.Attack4_Pre] 
            || animClipName == AnimDictionary[AnimPlayerNames.Attack4_End] || animClipName == AnimDictionary[AnimPlayerNames.Attack3_End])
        {
            
            smashParticle.SetActive(true);
            trail.SetActive(false);
            ShakeCameraDamage(1, 1, 0.3f);
        }
    }

    public IEnumerator SlowAnimSpeed()
    {
        if (!slowSpeed)
        {
            slowSpeed = true;
            anim.speed = 0;
            yield return new WaitForSeconds(0.1f);
            anim.speed = 1;
            slowSpeed = false;
        }
    }

    public void Start()
    {
        var clips = anim.runtimeAnimatorController.animationClips.ToList();

        // Iterate over the clips and gather their information
        /*int aux = 0;
        foreach (var animClip in clips)
        {
            Debug.Log(animClip.name + ": " + aux++);
        }
        */
        AnimDictionary.Add(AnimPlayerNames.Dead, clips[0].name);
        AnimDictionary.Add(AnimPlayerNames.Attack1_Pre, clips[1].name);
        AnimDictionary.Add(AnimPlayerNames.Attack1_Damage, clips[2].name);
        AnimDictionary.Add(AnimPlayerNames.Attack1_End, clips[3].name);
        AnimDictionary.Add(AnimPlayerNames.Attack2_Damage, clips[4].name);
        AnimDictionary.Add(AnimPlayerNames.Attack2_End, clips[5].name);
        AnimDictionary.Add(AnimPlayerNames.Attack2_Pre, clips[6].name);
        AnimDictionary.Add(AnimPlayerNames.Attack3_Damage, clips[7].name);
        AnimDictionary.Add(AnimPlayerNames.Attack3_End, clips[8].name);
        AnimDictionary.Add(AnimPlayerNames.Attack3_Pre, clips[9].name);
        AnimDictionary.Add(AnimPlayerNames.Attack4_Damage, clips[10].name);
        AnimDictionary.Add(AnimPlayerNames.Attack4_End, clips[11].name);
        AnimDictionary.Add(AnimPlayerNames.Attack4_Pre, clips[12].name);
        AnimDictionary.Add(AnimPlayerNames.Parry1, clips[13].name);
        AnimDictionary.Add(AnimPlayerNames.Parry2, clips[14].name);
        AnimDictionary.Add(AnimPlayerNames.Parry3, clips[15].name);
        AnimDictionary.Add(AnimPlayerNames.Parry4, clips[16].name);
        AnimDictionary.Add(AnimPlayerNames.BackAttack2, clips[17].name);
        AnimDictionary.Add(AnimPlayerNames.TurnAttack_Pre, clips[18].name);
        AnimDictionary.Add(AnimPlayerNames.TurnAttack_Damage, clips[19].name);
        AnimDictionary.Add(AnimPlayerNames.TurnAttack_End, clips[20].name);
        AnimDictionary.Add(AnimPlayerNames.TakeDamage2, clips[22].name);
        AnimDictionary.Add(AnimPlayerNames.TakeDamage3, clips[23].name);
        AnimDictionary.Add(AnimPlayerNames.TakeDamage1, clips[24].name);
        AnimDictionary.Add(AnimPlayerNames.Defence, clips[26].name);
        AnimDictionary.Add(AnimPlayerNames.Blocked, clips[27].name);
        AnimDictionary.Add(AnimPlayerNames.FailDefence, clips[28].name);
        AnimDictionary.Add(AnimPlayerNames.Kick, clips[29].name);
        AnimDictionary.Add(AnimPlayerNames.IdleCombat, clips[58].name);
        AnimDictionary.Add(AnimPlayerNames.WalkW, clips[36].name);
        AnimDictionary.Add(AnimPlayerNames.WalkS, clips[37].name);
        AnimDictionary.Add(AnimPlayerNames.WalkD, clips[38].name);
        AnimDictionary.Add(AnimPlayerNames.WalkA, clips[39].name);
        AnimDictionary.Add(AnimPlayerNames.RunCombat, clips[31].name);
        AnimDictionary.Add(AnimPlayerNames.Run, clips[32].name);
        AnimDictionary.Add(AnimPlayerNames.Walk, clips[33].name);
        AnimDictionary.Add(AnimPlayerNames.Idle, clips[34].name);
        AnimDictionary.Add(AnimPlayerNames.Roll, clips[41].name);
        AnimDictionary.Add(AnimPlayerNames.RollAttack, clips[42].name);
        AnimDictionary.Add(AnimPlayerNames.RollEstocada_Damage, clips[43].name);
        AnimDictionary.Add(AnimPlayerNames.Dodge_Back, clips[45].name);
        AnimDictionary.Add(AnimPlayerNames.Dodge_Left, clips[46].name);
        AnimDictionary.Add(AnimPlayerNames.Dodge_Right, clips[47].name);


    }

    public void Update()
    {
        animClipName = model.animClipName;

        if (animClipName == "TakeSword.V3")
        {
            timeToSaveSword += Time.deltaTime;
            if (timeToSaveSword >= 0.1f)
            {
                BackTakeSword2();
                timeToSaveSword = 0;
            }
        }
        else timeToSaveSword =0;

        if (anim.GetBool("TakeSword2") && anim.GetBool("SaveSword2"))
        {
            anim.SetBool("TakeSword2", false);
            anim.SetBool("SaveSword2", false);
            anim.SetLayerWeight(1, 0);
            anim.SetLayerWeight(0, 1);
        }

        if (anim.GetBool("RollAttack")) anim.SetInteger("TakeDamage", 0);

        var velocityX = Input.GetAxis("Vertical");
        var velocityZ = Input.GetAxis("Horizontal");

        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.S)) velocityZ = 0;
  
        if (velocityX > 1) velocityX = 1;
        if (velocityZ > 1) velocityZ = 1;

        if (velocityX == 0 && velocityZ == 0) anim.SetBool("IdleCombat", true);
        else  anim.SetBool("IdleCombat", false);

        anim.SetFloat("VelX", velocityX);
        anim.SetFloat("VelZ", velocityZ);

        
    }

    public void RollAttackAntisipation()
    {
        antisipationRing.Clear();
        antisipationRing.Play();
    }

    public void DodgeLeftAnim()
    {
        anim.SetBool("DodgeLeft", true);
    }

    public void DogeRightAnim()
    {
        anim.SetBool("DodgeRight", true);
    }

    public void DogeBackAnim()
    {
        anim.SetBool("DodgeBack", true);
    }

    public void EndDodge()
    {
        anim.SetBool("DodgeBack", false);
        anim.SetBool("DodgeRight", false);
        anim.SetBool("DodgeLeft", false);
    }

    public void  CanRollAttack()
    {
        anim.SetBool("CanRollAttack", true);
    }

    public void RollAttackAnim()
    {
        anim.SetBool("RollAttack", true);
        anim.SetBool("CanRollAttack", false);
    }

    public void RollAttackAnimFalse()
    {
        anim.SetBool("RollAttack", false);
        anim.SetBool("CanRollAttack", false);
    }

    public void ParryAnim()
    {
        anim.SetBool("Parry", true);
        currentAttackAnimation = 0;
        model.countAnimAttack = 0;
    }

    public void ParryAnimFalse()
    {
        anim.SetBool("Parry", false);
    }

    public void Streak()
    {
        anim.SetBool("Streak", true);
        model.onPowerState = true;
    }

    public void StreakFalse()
    {
        anim.SetBool("Streak", false);
        model.onPowerState = false;
    }

    public void Awake()
    {
        trail.SetActive(false);
        anim.SetLayerWeight(1, 0);
        cam = GameObject.Find("Main Camera").GetComponent<CamController>();
        headBaseRot = head.transform.rotation;

        startFade.enabled = true;
        startFade.CrossFadeAlpha(0, fadeTime, false);
    }

    public void SaveSwordAnim2()
    {
        anim.SetLayerWeight(1, 1);
        anim.SetBool("SaveSword2", true);
        anim.SetBool("Defence", false);
    }

    public void BackSaveSword()
    {
        StartCoroutine(SaveSwordAnim());
        anim.SetBool("IdleCombat", false);
        anim.SetBool("Idle", true);
        anim.SetBool("SaveSword2", false);
        anim.SetBool("Defence", false);
    }

    public void TakeSword2()
    {
        anim.SetLayerWeight(1, 1);
        anim.SetBool("TakeSword2", true);
        anim.SetBool("Defence", false);
    }

    public void BackTakeSword2()
    {
        StartCoroutine(TakeSwordAnim());
        anim.SetBool("IdleCombat", true);
        anim.SetBool("Idle", false);
        anim.SetBool("TakeSword2", false);
        anim.SetBool("Defence", false);
    }

    public void RollAnim()
    {
        anim.SetBool("Roll", true);
    }

    public void BackRollAnim()
    {
        anim.SetBool("Roll", false);
        anim.SetBool("CanRollAttack", false);
        model.onRoll = false;
    }

    public void Blocked()
    {
        anim.Play("Blocked");
    }

    public void BlockedFail()
    {
        anim.Play("P_Warrior_FailDefence");
    }

    public void AwakeTrail()
    {
        trail.SetActive(true);
    }

    public void SleepTrail()
    {
        trail.SetActive(false);
    }

    public void RunSword()
    {
        anim.SetBool("runSword", true);
    }

    public void TrotAnim()
    {
        anim.SetBool("trotAnim", true);
    }

    public void FalseTrotAnim()
    {
        anim.SetBool("trotAnim", false);
    }

    public void RunAnim()
    {
        anim.SetBool("runAnim", true);
        anim.SetBool("WalkW", false);
        anim.SetBool("WalkS", false);
        anim.SetBool("WalkD", false);
        anim.SetBool("WalkA", false);
    }

    public void FalseRunAnim()
    {

        anim.SetBool("runAnim", false);
    }

    public void FalseAnimRunSword()
    {
        anim.SetBool("runSword", false);
    }


    public void FalseAnimWalk()
    {
        anim.SetBool("runSword", false);
        anim.SetBool("WalkW", false);
        anim.SetBool("WalkS", false);
        anim.SetBool("WalkD", false);
        anim.SetBool("WalkA", false);

    }

    public void UpdateLifeBar(float val)
    {
        StartCoroutine(BarSmooth(val, lifeBar));
    }

    public void UpdateStaminaBar(float val)
    {
        StartCoroutine(BarSmooth(val, staminaBar));
    }

    public void UpdateManaBar(float val)
    {
        StartCoroutine(BarSmooth(val, manaBar));
    }

    public void UpdateArmorBar(float val)
    {
        //StartCoroutine(BarSmooth(val, armor));
    }



    public void CounterAttackAnim()
    {
        anim.SetBool("CounterAttack",true);
    }

    public void CounterAttackFalse()
    {
        anim.SetBool("CounterAttack", false);
    }

    public IEnumerator BarSmooth(float target, Image barToAffect)
    {
        bool timerRunning = true;
        float smoothTimer = 0;

        float current = barToAffect.fillAmount;

        if (current - target <= 0.025f)
            barToAffect.fillAmount = target;

        while (timerRunning)
        {
            smoothTimer += Time.deltaTime * 1.5f;
            barToAffect.fillAmount = Mathf.Lerp(current, target, smoothTimer);
            if (smoothTimer > 1)
                timerRunning = false;
            yield return new WaitForEndOfFrame();
        }
    }

    public void UpdatePotions(int i)
    {
        potions[i].fillAmount = (float)model.potions[i] / 3;

    }

    public void UpdateTimer(string val = "")
    {
        potionTimer.text = val.ToString();
    }

    public void TogglePause()
    {
        if (!youWin.activeSelf && !youDied.activeSelf)
        {
            if (pauseMenu.activeSelf)
            {
                pauseMenu.SetActive(false);
                Time.timeScale = 1;
                cam.blockMouse = true;
                model.rb.velocity = Vector3.zero;
            }
            else
            {
                pauseMenu.SetActive(true);
                Time.timeScale = 0;
                cam.blockMouse = false;
                model.rb.velocity = Vector3.zero;
            }
        }
    }

    public void LookAtEnemy()
    {
        if (model.closestEnemy != null)
            head.LookAt(model.closestEnemy);
        else
            head.rotation = headBaseRot;
    }

    public IEnumerator SlowSpeed()
    {
        anim.speed = 0f;
        yield return new WaitForSeconds(0.025f);
        anim.speed = 1;
    }

    public void UpdatePowerCD(int id, float fa)
    {
        switch (id)
        {
            case 1:
                power1.fillAmount = fa;
                break;
            case 2:
                power2.fillAmount = fa;
                break;
            case 3:
                power3.fillAmount = fa;
                break;
            case 4:
                power4.fillAmount = fa;
                break;
        }
    }


    public void DesactivateLayer()
    {
        //  anim.SetLayerWeight(1, 0);
        anim.SetBool("SaveSword", false);
        anim.SetBool("TakeSword", false);
    }

    public void BrokenDefence(float time)
    {
        defenceColdwon.gameObject.SetActive(true);
        defenceColdwon.fillAmount = time;
    }

    public void Defence()
    {
        anim.SetBool("Defence", true);
        defenceActive.gameObject.SetActive(true);
    }

    public void NoDefence()
    {
        anim.SetBool("Defence", false);
        defenceActive.gameObject.SetActive(false);
    }

    public void ReciveDamage()
    {

        blood.Play();
        if (!model.onPowerState)
        {
            ShakeCameraDamage(1, 1.5f, 0.5f);
            var random = Random.Range(1, 4);
            anim.SetInteger("TakeDamage", random);
        }
    }

    public void ShakeCameraDamage(float frequency, float amplitude, float time )
    {
        cam.CamShake(frequency, amplitude, time);
    }

    public void NoReciveDamage()
    {
        anim.SetInteger("TakeDamage", 0);
    }

    public void BasicAttack()
    {
        cam.AttackCameraEffect();

        if (currentAttackAnimation == 3)
        {
            preAttacktime = 0.001f;
            StartCoroutine(SmashParticleEvent());
        }
        currentAttackAnimation++;
        anim.SetInteger("AttackAnim", currentAttackAnimation);
    }
 


    public void Dead()
    {
        anim.SetBool("IsDead", true);
    }

    public IEnumerator YouDied()
    {
        yield return new WaitForSeconds(0.5f);
        youDied.gameObject.SetActive(true);
        var tempColor = youDied.GetComponent<Image>().color;
        var alpha = 0f;
        while (alpha <= 1)
        {
            alpha += 0.5f * Time.deltaTime;
            tempColor.a = alpha;
            youDied.GetComponent<Image>().color = tempColor;
            if (alpha >= 1)
            {
                for (int i = 0; i < youDied.transform.childCount; i++)
                    youDied.transform.GetChild(i).gameObject.SetActive(true);
                Time.timeScale = 0;
                cam.blockMouse = false;
            }
            yield return new WaitForEndOfFrame();
        }
    }

    public IEnumerator YouWin()
    {
        youWin.gameObject.SetActive(true);
        var tempColor = youWin.GetComponent<Image>().color;
        var alpha = 0f;
        while (alpha <= 1)
        {
            alpha += 0.75f * Time.deltaTime;
            if (alpha > 1) alpha = 1;
            tempColor.a = alpha;
            youWin.GetComponent<Image>().color = tempColor;
            if (alpha >= 1)
            {
                for (int i = 0; i < youDied.transform.childCount; i++)
                    youWin.transform.GetChild(i).gameObject.SetActive(true);
                Time.timeScale = 0;
                cam.blockMouse = false;
            }
            yield return new WaitForEndOfFrame();
        }
    }

}
