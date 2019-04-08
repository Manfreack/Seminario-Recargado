using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    [Header("Speed out of the fight:")]
    public float _SpeedWalk = 1.2f;
    public float _SpeedRun = 4f;

    [Header("Speed in the fight:")]
    public float _SpeedWalkFight = 1.5f;
    public float _SpeedRunFight = 5.0f;


    public Model model;
    public Viewer view;
    public GameObject text;
    bool smashBool;
    public bool useSword;
    public bool pushW;
    public bool pushS;
    public bool pushA;
    public bool pushD;

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
        model.Estocada += view.Estocada;
        model.RotateAttack += view.GolpeGiratorio;
        model.SaltoyGolpe1 += view.SaltoyGolpe1;
        model.SaltoyGolpe2 += view.SaltoyGolpe2;
        model.Uppercut += view.Uppercut;
        model.Dead += view.Dead;
        model.Trot += view.TrotAnim;
        model.Run += view.RunAnim;
        model.Fall += view.Falling;
        model.BlockEvent += view.Blocked;
        model.RollEvent += view.RollAnim;
    }

    // Update is called once per frame
    void Update()
    {
        

        if (!model.isPlatformJumping)
        {
            if (Input.GetKeyDown(KeyCode.Space) && pushD && !pushW && !pushS && !model.onRoll) model.Roll(transform.right);

            if (Input.GetKeyDown(KeyCode.Space) && pushA && !pushW && !pushS && !model.onRoll) model.Roll(-transform.right);

            if (Input.GetKeyDown(KeyCode.Space) && pushW && !pushS && !pushD && !pushA && !model.onRoll) model.Roll(transform.forward);

            if (Input.GetKeyDown(KeyCode.Space) && pushS && !pushW && !pushD && !pushA && !model.onRoll)
            {
                model.Roll(-model.transform.forward);
            }
            if (Input.GetKeyDown(KeyCode.Space) && pushW && pushD && !pushS && !model.onRoll) model.Roll(transform.forward);

            if (Input.GetKeyDown(KeyCode.Space) && pushW && pushA && !pushS && !model.onRoll) model.Roll(transform.forward);

            if (Input.GetKeyDown(KeyCode.Space) && pushS && pushD && !pushW && !model.onRoll) model.Roll(-transform.forward);

            if (Input.GetKeyDown(KeyCode.Space) && pushS && pushA && !pushW && !model.onRoll) model.Roll(-transform.forward);

            /*  if (Input.GetKeyUp(KeyCode.Alpha1)) model.CastPower1();

              if (Input.GetKeyUp(KeyCode.Alpha2)) model.CastPower2();

              if (Input.GetKeyUp(KeyCode.Alpha3)) model.CastPower3();

              if (Input.GetKeyUp(KeyCode.Alpha4)) model.CastPower4();
              */
            if (Input.GetKey(KeyCode.E) && model.isInCombat)
            {
                model.Defence();
                view.Defence();
            }
            if (!Input.GetKey(KeyCode.E))
            {
                view.NoDefence();
                model.StopDefence();
            }

            if (Input.GetKeyUp(KeyCode.C) && !model.saveSword)
            {
                model.SaveSword();
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

            if (Input.GetKeyDown(KeyCode.W) || Input.GetKeyDown(KeyCode.S) || Input.GetKeyDown(KeyCode.D) || Input.GetKeyDown(KeyCode.A))
            {
                view.anim.SetBool("Idle", false);
                //view.anim.SetBool("IdleCombat", false);
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


            if (Input.GetKeyDown(KeyCode.Mouse0) && !model.onAir && model.countAnimAttack<4)
            {
                useSword = true;
                model.NormalAttack();
            }

            if (Input.GetKeyDown(KeyCode.E)) model.StartInteraction();

            if (Input.GetKeyDown(KeyCode.J)) StartCoroutine(model.PlatformJump());

            if (Input.GetKeyDown(KeyCode.Alpha1)) model.DrinkPotion(1);
            if (Input.GetKeyDown(KeyCode.Alpha3)) model.DrinkPotion(3);
        }

        if (Input.GetKeyDown(KeyCode.Escape)) view.TogglePause();
    }

    private void FixedUpdate()
    {
        if (!model.isInCombat)
        {
            if (pushW && !pushA && !firstPushS && !pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushW = true;
                model.Movement(model.mainCamera.forward);
            }

            if (pushS && !pushA && !firstPushW && !pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushS = true;
                model.Movement(-model.mainCamera.forward);
            }

            if (pushA && !firstPushD && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushA = true;
                model.Movement(-model.mainCamera.right);
            }

            if (pushD && !firstPushA && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = _SpeedWalk;
                model.runSpeed = _SpeedRun;
                firstPushD = true;
                model.Movement(model.mainCamera.right);
            }

            if (pushW && pushA && !firstPushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.4f;
                model.runSpeed = 4.6f;
                firstPushW = true;
                if(!firstPushD) firstPushA = true;
                Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                if(firstPushA) model.Movement(dir);
            }

            if (pushW && !firstPushA && !firstPushS && pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.4f;
                model.runSpeed = 4.6f;
                firstPushW = true;
                if (!firstPushA) firstPushD = true;
                Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                if(firstPushD) model.Movement(dir);
            }

            if (!firstPushW && pushA && pushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.4f;
                model.runSpeed = 4.6f;
                firstPushS = true;
                if (!firstPushD) firstPushA = true;
                Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                if (firstPushA) model.Movement(dir);
            }

            if (!firstPushW && !firstPushA && pushS && pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.4f;
                model.runSpeed = 4.6f;
                firstPushS = true;
                if (!firstPushA) firstPushD = true;
                Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                if (firstPushD) model.Movement(dir);
            }

        }

        else
        {
            if (pushW && !pushA && !firstPushS && !pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.5f;
                model.runSpeed = _SpeedRunFight;
                firstPushW = true;
                model.CombatMovement(model.mainCamera.forward, true, false);
            }

            if (pushS && !pushA && !firstPushW && !pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                firstPushS = true;
                model.speed = 1.5f;
                model.runSpeed = _SpeedRunFight;
                model.CombatMovement(-model.mainCamera.forward, false, true);
            }

            if (pushA && !firstPushD && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.5f;
                model.runSpeed = _SpeedRunFight;
                firstPushA = true;
                model.CombatMovement(-model.mainCamera.right, false, true);
            }

            if (pushD && !firstPushA && !pushS && !pushW && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 1.5f;
                model.runSpeed = _SpeedRunFight;
                firstPushD = true;
                model.CombatMovement(model.mainCamera.right, false, true);
            }

            if (pushW && pushA && !firstPushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0)
            {
                firstPushW = true;
                model.speed = 2f;
                model.runSpeed = 4f;
                if (!firstPushD) firstPushA = true;
                Vector3 dir = (model.mainCamera.forward + -model.mainCamera.right) / 2;
                if(firstPushA) model.CombatMovement(dir, true, false);
            }

            if (pushW && !firstPushA && !firstPushS && pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                firstPushW = true;
                model.speed = 2f;
                model.runSpeed = 4f;
                if (!firstPushA) firstPushD = true;
                Vector3 dir = (model.mainCamera.forward + model.mainCamera.right) / 2;
                if (firstPushD) model.CombatMovement(dir, true, false);
            }

            if (!firstPushW && pushA && pushS && !firstPushD && !model.isDead && model.countAnimAttack <= 0)
            {
                firstPushS = true;
                model.speed = 2f;
                model.runSpeed = 4f;
                if (!firstPushD) firstPushA = true;
                Vector3 dir = (-model.mainCamera.forward + -model.mainCamera.right) / 2;
                if (firstPushA) model.CombatMovement(dir, false, true);
            }

            if (!firstPushW && !firstPushA && pushS && pushD && !model.isDead && model.countAnimAttack <= 0)
            {
                model.speed = 2f;
                model.runSpeed = 3.8f;
                firstPushS = true;
                if (!firstPushA) firstPushD = true;
                Vector3 dir = (-model.mainCamera.forward + model.mainCamera.right) / 2;
                if (firstPushD) model.CombatMovement(dir, false, true);
            }
        }      
    }
}


