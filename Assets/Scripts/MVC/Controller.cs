using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    [Header("Speed out of the fight:")]
    public float _SpeedWalk = 0.9f;
    public float _SpeedRun = 2.8f;

    [Header("Speed in the fight:")]
    public float _SpeedWalkFight = 1.2f;
    public float _SpeedRunFight = 2f;


    public Model model;
    public Viewer view;
    public GameObject text;
    bool smashBool;
    public bool useSword;
    public bool pushW;
    public bool pushS;
    public bool pushA;
    public bool pushD;
    public CamController Cam;

    public bool firstPushW;
    public bool firstPushS;
    public bool firstPushA;
    public bool firstPushD;

    float count;
    bool pushCount;

    public IEnumerator DelaySmash()
    {
        smashBool = true;
        yield return new WaitForSeconds(0.2f);
        smashBool = false;
    }

    // Use this for initialization
    void Awake()
    {
        model.Attack += view.BasicAttack;
        model.OnDamage += view.ReciveDamage;       
        model.Dead += view.Dead;
        model.Trot += view.TrotAnim;
        model.Run += view.RunAnim;
        model.BlockEvent += view.Blocked;
        model.RollEvent += view.RollAnim;
        model.DefenceEvent += view.Defence;
        model.StopDefenceEvent += view.NoDefence;
        model.StreakEvent += view.Streak;
        model.RollAttackEvent += view.RollAttackAnim;
        model.CounterAttackEvent += view.CounterAttackAnim;
        model.DogeBackEvent += view.DogeBackAnim;
        model.DogeLeftEvent += view.DodgeLeftAnim;
        model.DogeRightEvent += view.DogeRightAnim;

        Cam = FindObjectOfType<CamController>();

    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.E) && model.isInCombat)
        {
            model.LockEnemies();
        }

        if(Input.GetKeyDown(KeyCode.Tab))
        {
            model.ChangeTarget();
        }

        if (!model.isPlatformJumping && model.fadeTimer > view.fadeTime && !view.pauseMenu.activeSelf)
        {         

            if(Input.GetKeyDown(KeyCode.Q))
            {
                model.CastPower2();
            }

            if (Input.GetKey(KeyCode.Mouse1) && model.isInCombat && model.stamina>5)
            {
                view.anim.SetBool("PressDefence", true);
                model.Defence();
            }
            if (!Input.GetKey(KeyCode.Mouse1))
            {
                view.anim.SetBool("PressDefence", false);
                model.StopDefence();
            }        
            
            if (Input.GetKeyUp(KeyCode.W) || Input.GetKeyUp(KeyCode.S) || Input.GetKeyUp(KeyCode.D) || Input.GetKeyUp(KeyCode.A))
            {

                if (!model.isRuning) view.FalseTrotAnim();
                view.FalseAnimWalk();
            }
        
            if (!Input.GetKey(KeyCode.W) && !Input.GetKey(KeyCode.S) && !Input.GetKey(KeyCode.D) && !Input.GetKey(KeyCode.A))
            {
                if(!view.anim.GetBool("IdleCombat")) view.anim.SetBool("Idle", true);
                model.acceleration = 0;
                view.FalseAnimRunSword();
                view.FalseRunAnim();
            }

            if ((Input.GetKeyUp(KeyCode.D) && Input.GetKey(KeyCode.A)) || (Input.GetKeyUp(KeyCode.A) && Input.GetKey(KeyCode.D)) 
                || (Input.GetKeyUp(KeyCode.W) && Input.GetKey(KeyCode.S)) || (Input.GetKeyUp(KeyCode.S) && Input.GetKey(KeyCode.W)))
            {
                model.acceleration = 0;
            }

            if (Input.GetKeyDown(KeyCode.W) || Input.GetKeyDown(KeyCode.S) || Input.GetKeyDown(KeyCode.D) || Input.GetKeyDown(KeyCode.A))
            {
                view.anim.SetBool("Idle", false);
            }

            if (!Input.GetKey(KeyCode.W))
            {
                pushW = false;
                firstPushW = false;
            }

            if (!Input.GetKey(KeyCode.S))
            {
                pushS = false;
                firstPushS = false;
            }

            if (!Input.GetKey(KeyCode.D))
            {
                pushD = false;
                firstPushD = false;
            }

            if (!Input.GetKey(KeyCode.A))
            {
                pushA = false;
                firstPushA = false;
            }

            if (Input.GetKey(KeyCode.W)) pushW = true;
            if (Input.GetKey(KeyCode.S)) pushS = true;
            if (Input.GetKey(KeyCode.D)) pushD = true;
            if (Input.GetKey(KeyCode.A)) pushA = true;
         

            if (Input.GetKey(KeyCode.LeftShift) && model.stamina>5 )
            {
               view.FalseTrotAnim();
               model.isRuning = true;
            }

            if (!Input.GetKey(KeyCode.LeftShift))
            {
                view.FalseRunAnim();
                model.isRuning = false;
            }

            if (Input.GetKeyUp(KeyCode.LeftShift)) model.acceleration = 0;


            if (Input.GetKeyDown(KeyCode.Mouse0) && model.countAnimAttack<4)
            {
                useSword = true;

                if (!pushW && !pushA && !pushS && !pushD) model.NormalAttack(new Vector3(0,0,0));
                if (pushW && !pushA && !firstPushS && !pushD) model.NormalAttack(model.mainCamera.forward);
                if (pushS && !pushA && !firstPushW && !pushD) model.NormalAttack(-model.mainCamera.forward);
                if (pushA && !firstPushD && !pushS && !pushW) model.NormalAttack(-model.mainCamera.right);
                if (pushD && !firstPushA && !pushS && !pushW) model.NormalAttack(model.mainCamera.right);

                if (pushW && pushA && !firstPushS && !firstPushD)
                {
                    Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                    model.NormalAttack(dir);
                }

                if (pushW && !firstPushA && !firstPushS && pushD)
                {                  
                    Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                    model.NormalAttack(dir);
                }

                if (!firstPushW && pushA && pushS && !firstPushD)
                {                  
                    Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                    model.NormalAttack(dir);
                }

                if (!firstPushW && !firstPushA && pushS && pushD)
                {
                    Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                    model.NormalAttack(dir);
                }

            }

            if (Input.GetKeyDown(KeyCode.Space) && model.animClipName != "GetDamage1" && model.animClipName != "GetDamage2" && model.animClipName != "GetDamage3" && model.isInCombat && model.timeToRoll <= 0)
            {
                if (!pushW && !pushA && !pushS && !pushD) model.Roll(model.transform.forward, Model.DogeDirecctions.Roll);
                if (pushW && !pushA && !firstPushS && !pushD) model.Roll(model.mainCamera.forward, Model.DogeDirecctions.Roll);
                if (pushS && !pushA && !firstPushW && !pushD) model.Roll(-model.mainCamera.forward, Model.DogeDirecctions.Back);
                if (pushA && !firstPushD && !pushS && !pushW) model.Roll(-model.mainCamera.right, Model.DogeDirecctions.Right);
                if (pushD && !firstPushA && !pushS && !pushW) model.Roll(model.mainCamera.right, Model.DogeDirecctions.Left);

                if (pushW && pushA && !firstPushS && !firstPushD)
                {
                    Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                    model.Roll(dir.normalized, Model.DogeDirecctions.Roll);
                }

                if (pushW && !firstPushA && !firstPushS && pushD)
                {
                    Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                    model.Roll(dir.normalized, Model.DogeDirecctions.Roll);
                }

                if (!firstPushW && pushA && pushS && !firstPushD)
                {
                    Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                    model.Roll(dir.normalized, Model.DogeDirecctions.Back);
                }

                if (!firstPushW && !firstPushA && pushS && pushD)
                {
                    Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                    model.Roll(dir.normalized, Model.DogeDirecctions.Back);
                }
            }

            if (Input.GetKeyDown(KeyCode.Space) &&  !model.isInCombat && model.timeToRoll<=0)
            {
                if (!pushW && !pushA && !pushS && !pushD) model.Roll(model.transform.forward, Model.DogeDirecctions.Roll);
                if (pushW && !pushA && !firstPushS && !pushD) model.Roll(model.mainCamera.forward, Model.DogeDirecctions.Roll);
                if (pushS && !pushA && !firstPushW && !pushD) model.Roll(-model.mainCamera.forward, Model.DogeDirecctions.Roll);
                if (pushA && !firstPushD && !pushS && !pushW) model.Roll(-model.mainCamera.right, Model.DogeDirecctions.Roll);
                if (pushD && !firstPushA && !pushS && !pushW) model.Roll(model.mainCamera.right, Model.DogeDirecctions.Roll);

                if (pushW && pushA && !firstPushS && !firstPushD)
                {
                    Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                    model.Roll(dir, Model.DogeDirecctions.Roll);
                }

                if (pushW && !firstPushA && !firstPushS && pushD)
                {
                    Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                    model.Roll(dir, Model.DogeDirecctions.Roll);
                }

                if (!firstPushW && pushA && pushS && !firstPushD)
                {
                    Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                    model.Roll(dir, Model.DogeDirecctions.Roll);
                }

                if (!firstPushW && !firstPushA && pushS && pushD)
                {
                    Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                    model.Roll(dir, Model.DogeDirecctions.Roll);
                }
            }

            if (Input.GetKeyDown(KeyCode.E)) model.StartInteraction();

            if (Input.GetKeyDown(KeyCode.Alpha1)) model.DrinkPotion(1);
            if (Input.GetKeyDown(KeyCode.Alpha2)) model.DrinkPotion(2);
        }

        if(model.fadeTimer > view.fadeTime)
            if (Input.GetKeyDown(KeyCode.Escape)) view.TogglePause();
    }

    private void FixedUpdate()
    {
        if (!model.isInCombat && !model.onPowerState && Cam.PlayerCanMove == false && model.fadeTimer > view.fadeTime)
        {
            if (pushW && !pushA && !firstPushS && !pushD && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushW = true;
                model.Movement(model.mainCamera.forward);
            }

            if (pushS && !pushA && !firstPushW && !pushD && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushS = true;
                model.Movement(-model.mainCamera.forward);
            }

            if (pushA && !firstPushD && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushA = true;
                model.Movement(-model.mainCamera.right);
            }

            if (pushD && !firstPushA && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushD = true;
                model.Movement(model.mainCamera.right);
            }

            if (pushW && pushA && !firstPushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = 1.1f;
                model.runSpeed = 3.5f;
                firstPushW = true;
                if(!firstPushD) firstPushA = true;
                Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                if(firstPushA) model.Movement(dir);
            }

            if (pushW && !firstPushA && !firstPushS && pushD && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = 1.1f;
                model.runSpeed = 3.5f;
                firstPushW = true;
                if (!firstPushA) firstPushD = true;
                Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                if(firstPushD) model.Movement(dir);
            }

            if (!firstPushW && pushA && pushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = 1.1f;
                model.runSpeed = 3.5f;
                firstPushS = true;
                if (!firstPushD) firstPushA = true;
                Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                if (firstPushA) model.Movement(dir);
            }

            if (!firstPushW && !firstPushA && pushS && pushD && !model.isDead && model.countAnimAttack <= 0 && !model.onRoll)
            {
                model.speed = 1.1f;
                model.runSpeed = 3.5f;
                firstPushS = true;
                if (!firstPushA) firstPushD = true;
                Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                if (firstPushD) model.Movement(dir);
            }

        }

        if(model.isInCombat && !model.onPowerState && Cam.PlayerCanMove == false && model.fadeTimer > view.fadeTime && model.animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.TurnAttack_Damage]
                && model.animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.TurnAttack_End] && model.animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.TurnAttack_Pre] 
                && model.animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollAttack] && model.animClipName != view.AnimDictionary[Viewer.AnimPlayerNames.RollEstocada_Damage])
        {

            if (pushW && !pushA && !firstPushS && !pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    firstPushW = true;
                    if(!model.targetLockedOn) model.CombatMovement(model.mainCamera.forward, true, false, false);
                    else model.CombatMovement(model.transform.forward, true, false, false);
            }

            if (pushS && !pushA && !firstPushW && !pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                    firstPushS = true;
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    if (!model.targetLockedOn) model.CombatMovement(-model.mainCamera.forward, false, true, false);
                    else model.CombatMovement(-model.transform.forward, false, true, false);
                
            }

            if (pushA && !firstPushD && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0)
            {
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    firstPushA = true;
                    if (!model.targetLockedOn) model.CombatMovement(-model.mainCamera.right, false, true, false);
                    else model.CombatMovement(-model.transform.right, false, true, false);
            }

            if (pushD && !firstPushA && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0)
            {
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    firstPushD = true;
                    if (!model.targetLockedOn) model.CombatMovement(model.mainCamera.right, false, true, false); 
                    else model.CombatMovement(model.transform.right, false, true, false); 
            }

            if (pushW && pushA && !firstPushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0 )
            {
                    firstPushW = true;
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    if (!firstPushD) firstPushA = true;
                    Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                    if(firstPushA) model.CombatMovement(dir.normalized, true, false, false);
            }

            if (pushW && !firstPushA && !firstPushS && pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                    firstPushW = true;
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    if (!firstPushA) firstPushD = true;
                    Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                    if (firstPushD) model.CombatMovement(dir.normalized, true, false, false);
            }

            if (!firstPushW && pushA && pushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0)
            {
                    firstPushS = true;
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    if (!firstPushD) firstPushA = true;
                    Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                    if (firstPushA) model.CombatMovement(dir.normalized, false, false, true);
            }

            if (!firstPushW && !firstPushA && pushS && pushD && !model.isDead && model.countAnimAttack <= 0 )
            {
                    model.speed = _SpeedWalkFight;
                    model.runSpeed = _SpeedRunFight;
                    firstPushS = true;
                    if (!firstPushA) firstPushD = true;
                    Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                    if (firstPushD) model.CombatMovement(dir.normalized, false, false, true);
            }
        }      
    }
}


