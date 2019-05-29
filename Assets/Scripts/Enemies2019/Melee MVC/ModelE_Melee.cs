using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelE_Melee : EnemyEntity
{

    public enum EnemyInputs { PATROL, PERSUIT, WAIT, ATTACK, RETREAT , FOLLOW, DIE, ANSWER, DEFENCE, STUNED }
    public EventFSM<EnemyInputs> _myFsm;
    public List<CombatNode> restOfNodes = new List<CombatNode>();
    public float timeToPatrol;
    public LayerMask layerPlayer;
    public LayerMask layerObst;
    public LayerMask layerObstAndBarrels;
    public LayerMask layerEntites;
    public LayerMask layerAttack;
    public bool timeToAttack;
    public EnemyCombatManager cm;
    public List<ModelE_Melee> myWarriorFriends = new List<ModelE_Melee>();
    public Transform attackPivot;
    public ViewerE_Melee _view;
    public float distanceToHit;
    public float angleToHit;
    public float timeToChangeRotation;
    public bool onAttackArea;
    public bool firstAttack;
    public bool checkTurn;
    public bool changeRotateWarrior;
    public bool alreadyChangeDir;
    public bool onDefence;
    public int flankDir;
    public bool damageDone;
    public float speedRotation;
    bool firstHit;
    public bool impulse;
    public int changeRing;
    Vector3 lastPosition;
    Vector3 nearRingPosition;
    public string animClipName;
    public float timeReposition;
    public float timeReposition2;

    public Action TakeDamageEvent;
    public Action DeadEvent;
    public Action AttackEvent;
    public Action HeavyAttackEvent;
    public Action MoveEvent;
    public Action IdleEvent;
    public Action BlockedEvent;
    public Action CombatIdleEvent;
    public Action CombatWalkEvent;
    public Action WalkBackEvent;
    public Action WalkLeftEvent;
    public Action WalkRightEvent;
    public Action DefenceEvent;
    public Action HitDefenceEvent;
    public Action AttackRunEvent;
    public Action StunedEvent;
    public Node endPatrolNode;

    float maxLife;
    public float timeToRetreat;
    float distanceRetreat;
    float maxViewDistanceToAttack;
    Vector3 vectoToNodeRetreat;

    [Header("Enemy Combat:")]

    public float timeMinAttack;
    public float timeMaxAttack;
    public float timeToHoldDefence;
    public float maxTimeToDefence;
    public float hitsToStartDefenceMAX;
    public float hitsToStartDefenceMIN;
    public float actualHits;

    [Header("Enemy States:")]

    public bool AttackState;
    public bool FollowsState;
    public bool PersuitState;
    public bool WaitState;
    public bool RetreatState;
    public bool reposition;
    public bool cooldwonReposition;

    bool delayWaitState;

    public IEnumerator ChangeDirRotation()
    {

        cooldwonReposition = true;
        yield return new WaitForSeconds(1);
        cooldwonReposition = true;
    }



    public void RepositionMoveRight()
    {
        timeReposition -= Time.deltaTime;
        if (timeReposition <= 0) timeReposition = 0;

        if (timeReposition > 0) rb.MovePosition(rb.position + (transform.forward + transform.right) * speedRotation * Time.deltaTime);


        if (timeReposition <= 0 && timeReposition2 > 0)
        {
            timeReposition2 -= Time.deltaTime;
            if (timeReposition2 <= 0) timeReposition2 = 0;
            rb.MovePosition(rb.position + (-transform.forward + transform.right) * speedRotation * Time.deltaTime);
        }

    }

    public IEnumerator AvoidWarriorRight()
    {
        timeReposition = 0.7f;
        timeReposition2 = 0.7f;
        reposition = true;
        while (timeReposition > 0)
        {
            RepositionMoveRight();
            yield return new WaitForEndOfFrame();
        }

        while (timeReposition2 > 0)
        {
            RepositionMoveRight();
            yield return new WaitForEndOfFrame();
        }

        cooldwonReposition = true;

        reposition = false;

        yield return new WaitForSeconds(1);

        cooldwonReposition = false;
    }

    public void RepositionMoveLeft()
    {
        timeReposition -= Time.deltaTime;
        if (timeReposition <= 0) timeReposition = 0;

        if (timeReposition > 0) rb.MovePosition(rb.position + (transform.forward - transform.right) * speedRotation * Time.deltaTime);


        if (timeReposition <= 0 && timeReposition2 > 0)
        {
            timeReposition2 -= Time.deltaTime;
            if (timeReposition2 <= 0) timeReposition2 = 0;
            rb.MovePosition(rb.position + (-transform.forward - transform.right) * speedRotation * Time.deltaTime);
        }

    }

    public IEnumerator AvoidWarriorLeft()
    {
        timeReposition = 0.7f;
        timeReposition2 = 0.7f;
        reposition = true;
        while (timeReposition > 0)
        {
            RepositionMoveLeft();
            yield return new WaitForEndOfFrame();
        }

        while (timeReposition2 > 0)
        {
            RepositionMoveLeft();
            yield return new WaitForEndOfFrame();
        }

        cooldwonReposition = true;

        reposition = false;

        yield return new WaitForSeconds(1);

        cooldwonReposition = false;
    }


    public IEnumerator RetreatCorrutineHeavy(float t)
    {
        yield return new WaitForSeconds(t);

        onRetreat = true;
    }

    public IEnumerator RetreatCorrutine(float t)
    {
        yield return new WaitForSeconds(t);

        if (!damageDone) StartCoroutine(RetreatCorrutine2(1.12f));

        else onRetreat = true;
    }

    public IEnumerator RetreatCorrutine2(float t)
    {
        yield return new WaitForSeconds(t);

        if (!damageDone) StartCoroutine(RetreatCorrutine3(0.23f));

        else onRetreat = true;
    }

    public IEnumerator RetreatCorrutine3(float t)
    {
        yield return new WaitForSeconds(t);
        onRetreat = true;
    }

    public IEnumerator DelayTurn()
    {
        yield return new WaitForSeconds(1);
        checkTurn = false;

    }

    public IEnumerator DelayChangeDirWarrior()
    {
        alreadyChangeDir = true;
        changeRotateWarrior = false;
        yield return new WaitForSeconds(2);
        changeRotateWarrior = true;
        alreadyChangeDir = false;
    }

    public IEnumerator OnDamageCorrutine()
    {
        onDamage = true;

        while (onDamage)
        {
            timeOnDamage -= Time.deltaTime;
            if (timeOnDamage <= 0) onDamage = false;
            yield return new WaitForEndOfFrame();
        }
    }

    public void Awake()
    {

        delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Melee>();
        maxLife = life;
        maxViewDistanceToAttack = viewDistanceAttack;
        actualHits = UnityEngine.Random.Range(hitsToStartDefenceMIN, hitsToStartDefenceMAX);
        changeRotateWarrior = true;
        timeStuned = 3;

        TakeDamageEvent += _view.TakeDamageAnim;
        DeadEvent += _view.DeadAnim;
        AttackEvent += _view.AttackAnim;
        HeavyAttackEvent += _view.HeavyAttackAnim;
        AttackRunEvent += _view.RunAttackAnim;
        IdleEvent += _view.IdleAnim;
        MoveEvent += _view.BackFromIdle;
        BlockedEvent += _view.BlockedAnim;
        CombatWalkEvent += _view.CombatWalkAnim;
        CombatIdleEvent += _view.CombatIdleAnim;
        WalkBackEvent += _view.WalckBackAnim;
        WalkLeftEvent += _view.WalkLeftAnim;
        WalkRightEvent += _view.WalkRightAnim;
        DefenceEvent += _view.DefenceAnim;
        HitDefenceEvent += _view.HitDefenceAnim;
        HitDefenceEvent += target.GetComponent<Viewer>().ParryAnim;
        StunedEvent += _view.StunedAnim;

        var patrol = new FSM_State<EnemyInputs>("PATROL");
        var defence = new FSM_State<EnemyInputs>("DEFENCE");
        var persuit = new FSM_State<EnemyInputs>("PERSUIT");
        var wait = new FSM_State<EnemyInputs>("WAIT");
        var attack = new FSM_State<EnemyInputs>("ATTACK");
        var retreat = new FSM_State<EnemyInputs>("RETREAT");
        var die = new FSM_State<EnemyInputs>("DIE");
        var follow = new FSM_State<EnemyInputs>("FOLLOW");
        var answerCall = new FSM_State<EnemyInputs>("ANSWER");
        var stuned = new FSM_State<EnemyInputs>("STUNED");

        StateConfigurer.Create(patrol)
           .SetTransition(EnemyInputs.PERSUIT, persuit)
           .SetTransition(EnemyInputs.ANSWER, answerCall)
           .SetTransition(EnemyInputs.WAIT, wait)
           .SetTransition(EnemyInputs.DIE, die)
           .Done();

        StateConfigurer.Create(stuned)
          .SetTransition(EnemyInputs.PERSUIT, persuit)
          .SetTransition(EnemyInputs.FOLLOW, follow)
          .SetTransition(EnemyInputs.WAIT, wait)
          .SetTransition(EnemyInputs.DIE, die)
          .Done();

        StateConfigurer.Create(persuit)
         .SetTransition(EnemyInputs.WAIT, wait)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.STUNED, stuned)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(wait)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.DEFENCE, defence)
         .SetTransition(EnemyInputs.STUNED, stuned)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(retreat)
       .SetTransition(EnemyInputs.PERSUIT, persuit)
       .SetTransition(EnemyInputs.FOLLOW, follow)
       .SetTransition(EnemyInputs.WAIT, wait)
       .SetTransition(EnemyInputs.DEFENCE, defence)
       .SetTransition(EnemyInputs.DIE, die)
       .Done();


        StateConfigurer.Create(attack)
        .SetTransition(EnemyInputs.PERSUIT, persuit)
        .SetTransition(EnemyInputs.DEFENCE, defence)
        .SetTransition(EnemyInputs.FOLLOW, follow)
        .SetTransition(EnemyInputs.WAIT, wait)
        .SetTransition(EnemyInputs.RETREAT, retreat)
        .SetTransition(EnemyInputs.STUNED, stuned)
        .SetTransition(EnemyInputs.DIE, die)
        .Done();


        StateConfigurer.Create(follow)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.STUNED, stuned)
         .SetTransition(EnemyInputs.WAIT, wait)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(defence)
           .SetTransition(EnemyInputs.PERSUIT, persuit)
           .SetTransition(EnemyInputs.FOLLOW, follow)
           .SetTransition(EnemyInputs.WAIT, wait)
           .SetTransition(EnemyInputs.STUNED, stuned)
           .SetTransition(EnemyInputs.DIE, die)
           .Done();

        StateConfigurer.Create(answerCall)
        .SetTransition(EnemyInputs.PERSUIT, persuit)
        .SetTransition(EnemyInputs.WAIT, wait)
        .SetTransition(EnemyInputs.DIE, die)
        .Done();

        StateConfigurer.Create(die).Done();

        patrol.OnFixedUpdate += () =>
        {
            timeToPatrol -= Time.deltaTime;
            currentAction = new A_Patrol(this);

            if ((!isDead && isPersuit && !isWaitArea && !target.view.startFade.enabled) || onDamage) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAnswerCall) SendInputToFSM(EnemyInputs.ANSWER);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        patrol.OnUpdate += () =>
        {
            timeToPatrol -= Time.deltaTime;
        };

        answerCall.OnFixedUpdate += () =>
        {
            currentAction = new A_FollowTarget(this);
            CombatWalkEvent();
            if (!isDead && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };


        persuit.OnFixedUpdate += () =>
        {

            if (aggressiveLevel == 1) viewDistanceAttack = 3.5f;

            if (aggressiveLevel == 2) viewDistanceAttack = 7f;

            PersuitState = true;

            _view._anim.SetBool("WalkBack", false);

            if (!onDamage) CombatWalkEvent();

            isAnswerCall = false;

            firstSaw = true;

            if (timeToAttack && aggressiveLevel == 1) delayToAttack -= Time.deltaTime;

            if (timeToAttack && aggressiveLevel == 2) delayToAttack -= Time.deltaTime / 2;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            currentAction = new A_Persuit(this);

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.WAIT);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (!isDead && !isPersuit && !isWaitArea) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        persuit.OnExit += x =>
        {

            PersuitState = false;
        };

        defence.OnEnter += x =>
        {
            timeToHoldDefence = maxTimeToDefence;

            onDefence = true;
        };

        defence.OnUpdate += () =>
        {

            DefenceEvent();

            timeToHoldDefence -= Time.deltaTime;

            currentAction = null;

            if (impulse && animClipName == "EM_CounterAttack")
            {
                transform.position += transform.forward * 2 * Time.deltaTime;
            }

            if (!isDead && !isPersuit && !isWaitArea && !onRetreat  && animClipName != "EM_CounterAttack" && animClipName != "IdelDefence" && timeToHoldDefence <= 0 || timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && !isWaitArea && isPersuit  && animClipName != "EM_CounterAttack" && animClipName != "IdelDefence" && timeToHoldDefence <= 0 || timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea && animClipName != "EM_CounterAttack" && animClipName != "IdelDefence" && timeToHoldDefence <= 0 || timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

     
        };

        defence.OnExit += x =>
        {
            actualHits = UnityEngine.Random.Range(2, 3);
            
            _view.DefenceAnimFalse();
        };

        wait.OnEnter += x =>
        {
            WaitState = true;

            onDefence = false;

            if (!timeToAttack) delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);

            _view._anim.SetBool("WalkBack", false);
            firstAttack = false;
            onRetreat = false;

            if (aggressiveLevel == 1) viewDistanceAttack = 5f;

            if (aggressiveLevel == 2) viewDistanceAttack = 8f;

            if (timeToChangeRotation <= 0) timeToChangeRotation = UnityEngine.Random.Range(1.5f, 3);

        };


        wait.OnUpdate += () =>
        {

                if (!reposition) timeToChangeRotation -= Time.deltaTime;

                if (timeToChangeRotation <= 0 && changeRotateWarrior)
                {
                    timeToChangeRotation = UnityEngine.Random.Range(0.5f, 1.5f);
                    flankDir = 2;
                    changeRotateWarrior = false;
                }

                if (timeToChangeRotation <= 0 && !changeRotateWarrior)
                {
                    flankDir = UnityEngine.Random.Range(0, 2);
                    timeToChangeRotation = UnityEngine.Random.Range(2, 3);
                    changeRotateWarrior = true;
                }

                var NearNodes = Physics.OverlapSphere(transform.position, distanceToHit).Where(y => y.GetComponent<CombatNode>()).Select(y => y.GetComponent<CombatNode>()).Where(y => y.myOwner == null).ToList();

                foreach (var item in NearNodes)
                {
                    item.myOwner = this;
                }

                if (NearNodes.Count() > 0)
                {
                    var restOfNodes = playerNodes;

                    foreach (var item in NearNodes)
                    {
                        restOfNodes.Remove(item);
                    }

                    foreach (var item in restOfNodes)
                    {
                        if (item.myOwner == this) item.myOwner = null;
                    }
                }

            currentAction = new A_WarriorWait(this, flankDir);

            WaitState = true;

            if (timeToAttack && aggressiveLevel == 1) delayToAttack -= Time.deltaTime;

            if (timeToAttack && aggressiveLevel == 2) delayToAttack -= Time.deltaTime / 2;

            angleToAttack = 110;

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!isDead && !isWaitArea && isPersuit && !onDefence) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isWaitArea && !isPersuit && !onDefence) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && delayToAttack <= 0 && !onDefence) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);


        };

        wait.OnExit += x =>
        {
            WaitState = false;

            if (aggressiveLevel == 1) viewDistanceAttack = 3.5f;

            if (aggressiveLevel == 2) viewDistanceAttack = 7f;
        };

        attack.OnEnter += x =>
        {
            onDefence = false;

            delayToAttack = 0;
            onRetreat = false;
            firstAttack = false;

            damageDone = false;
        };

        attack.OnFixedUpdate += () =>
        {


            AttackState = true;

            currentAction = new A_AttackMeleeWarrior(this);

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!isDead && !isWaitArea && isPersuit && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isPersuit && !isWaitArea && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (onRetreat && !onDefence) SendInputToFSM(EnemyInputs.RETREAT);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);


        };

        attack.OnExit += x =>
        {
            AttackState = false;
        };

        stuned.OnEnter += x =>
        {
            cm.times++;
            firstAttack = false;
            onRetreat = false;
            timeToAttack = false;
            onDefence = false;
            _view._anim.SetBool("WalkBack", false);
            _view.EndChainAttack();
            checkTurn = false;
            timeStuned = 3;
        };

        stuned.OnUpdate += () =>
        {
            timeStuned -= Time.deltaTime;

            currentAction = new A_Idle();

            if (timeStuned <= 0) isStuned = false;

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

            if (!isDead && isWaitArea && !onRetreat && timeStuned <=0) SendInputToFSM(EnemyInputs.WAIT);

            if (!isDead && isPersuit && !isWaitArea && !onRetreat && timeStuned <= 0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isPersuit && !isWaitArea && !onRetreat && timeStuned <= 0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && onRetreat && timeStuned <= 0) SendInputToFSM(EnemyInputs.FOLLOW);
        };

        stuned.OnExit += x =>
        {
            isStuned = false;
            _view.StunedAnimFalse();
        };

        retreat.OnEnter += x =>
        {
            onDefence = false;
            if (aggressiveLevel == 1) timeToRetreat = 1.5f;
            if (aggressiveLevel == 2) timeToRetreat = 3.5f;
        };

        retreat.OnFixedUpdate += () =>
        {
            RetreatState = true;

            currentAction = new A_WarriorRetreat(this);

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (!isDead && isPersuit && !isWaitArea && timeToRetreat <= 0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isPersuit && !isWaitArea && timeToRetreat <= 0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (!isDead && isWaitArea && timeToRetreat <= 0) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        retreat.OnUpdate += () =>
        {
            if (animClipName != "E_Warrior_Attack1" && animClipName != "E_Warrior_Attack2" && animClipName != "E_Warrior_Attack3" && animClipName != "Heavy Attack_EM" && animClipName != "Run_EM" && animClipName != "HitDefence") timeToRetreat -= Time.deltaTime;

            if ((_view._anim.GetBool("Attack") || _view._anim.GetBool("Attack2") || _view._anim.GetBool("Attack3") || _view._anim.GetBool("HeavyAttack")) && !isDead && !onDefence)
            {
                transform.LookAt(target.transform.position);
            }

            if (animClipName != "E_Warrior_Attack1" && animClipName != "E_Warrior_Attack2" && animClipName != "E_Warrior_Attack3") impulse = false;

            if (impulse && (animClipName == "E_Warrior_Attack1" || animClipName == "E_Warrior_Attack2" || animClipName == "E_Warrior_Attack3")) transform.position += transform.forward * 2 * Time.deltaTime;

        };

        retreat.OnExit += x =>
        {
            RetreatState = false;
            StopRetreat();
        };

        follow.OnEnter += x =>
        {

            pathToTarget.Clear();

            Node start = GetMyNode();
            Node end = GetMyTargetNode();

            var originalPathToTarget = MyBFS.GetPath(start, end, myNodes);
            pathToTarget.AddRange(originalPathToTarget);
            currentIndex = pathToTarget.Count;


        };

        follow.OnUpdate += () =>
        {

            if (!onDamage) CombatWalkEvent();

            if (!isDead && isPersuit && !isWaitArea) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.WAIT);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        follow.OnFixedUpdate += () =>
        {
            currentAction = new A_FollowTarget(this);
        };

        follow.OnExit += x =>
        {

            FollowsState = false;
        };

        die.OnEnter += x =>
        {
            DeadEvent();
            currentAction = null;
            timeToAttack = false;

            if (myWarriorFriends.Count > 0)
            {
                foreach (var item in myWarriorFriends)
                {
                    RemoveWarriorFriend(item);
                }
            }

            if (nearEntities.Count > 0)
            {
                foreach (var item in nearEntities)
                {
                    RemoveNearEntity(item);
                }
            }

            ca.myEntities--;
            cm.times++;
            cm.enemiesList.Remove(this);
        };

        _myFsm = new EventFSM<EnemyInputs>(patrol);

    }
    public void SendInputToFSM(EnemyInputs inp)
    {
        _myFsm.SendInput(inp);
    }

    public void FollowState()
    {
        SendInputToFSM(EnemyInputs.FOLLOW);
    }

    private void Start()
    {
        playerNodes.AddRange(FindObjectsOfType<CombatNode>());
    }

    private void Update()
    {


        animClipName = _view._anim.GetCurrentAnimatorClipInfo(0)[0].clip.name;

        _myFsm.Update();


        if (target != null)
        {

            isPersuit = SearchForTarget.SearchTarget(target.transform, viewDistancePersuit, angleToPersuit, transform, true, layerObst);

            isWaitArea = SearchForTarget.SearchTarget(target.transform, viewDistanceAttack, angleToAttack, transform, true, layerObst);

            onAttackArea = SearchForTarget.SearchTarget(target.transform, distanceToHit, angleToHit, transform, true, layerObst);


        }

    }

    private void FixedUpdate()
    {
        _myFsm.FixedUpdate();
        if (currentAction != null) currentAction.Actions();

    }

    public override Node GetMyNode()
    {
        var myNode = myNodes.OrderBy(x =>
        {
            var d = Vector3.Distance(x.transform.position, transform.position);
            return d;
        }).First();

        return myNode;
    }

    public override Node GetMyTargetNode()
    {
        var targetNode = myNodes.OrderBy(x =>
        {
            var d = Vector3.Distance(x.transform.position, target.transform.position);
            return d;

        }).First();

        return targetNode;
    }

    public override Node GetRandomNode()
    {
        var r = UnityEngine.Random.Range(0, myNodes.Count);
        return myNodes[r];
    }


    public override Vector3 ObstacleAvoidance()
    {
        var obs = Physics.OverlapSphere(transform.position, 1, layerObstAndBarrels).Where(x => !x.GetComponent<Model>());
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public void FillFriends()
    {
        myWarriorFriends.Clear();
        myWarriorFriends.AddRange(Physics.OverlapSphere(transform.position, viewDistancePersuit * 2)
                                        .Where(x => x.GetComponent<ModelE_Melee>())
                                        .Select(x => x.GetComponent<ModelE_Melee>()).Where(x => x != this));
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position, viewDistancePersuit);

        Vector3 rightLimit = Quaternion.AngleAxis(angleToPersuit, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit * viewDistancePersuit));

        Vector3 leftLimit = Quaternion.AngleAxis(-angleToPersuit, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit * viewDistancePersuit));

        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position, distanceToHit);

        Vector3 rightLimit3 = Quaternion.AngleAxis(angleToHit, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit3 * distanceToHit));

        Vector3 leftLimit3 = Quaternion.AngleAxis(-angleToHit, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit3 * distanceToHit));

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, viewDistanceAttack);

        Vector3 rightLimit2 = Quaternion.AngleAxis(angleToAttack, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit2 * viewDistanceAttack));

        Vector3 leftLimit2 = Quaternion.AngleAxis(-angleToAttack, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit2 * viewDistanceAttack));

        Gizmos.DrawWireSphere(attackPivot.position, radiusAttack);
    }

    public override Vector3 EntitiesAvoidance()
    {
        var obs = Physics.OverlapSphere(transform.position, 1, layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>()).Where(x => x != this);

        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public void Impulse()
    {
        impulse = true;
        lastPosition = transform.position;

    }

    public void StopImpulse()
    {
        impulse = false;
    }

    public override void GetDamage(float damage, string typeOfDamage)
    {
        Vector3 dir = transform.position - target.transform.position;
        float angle = Vector3.Angle(dir, transform.forward);


        if (!onDefence && typeOfDamage =="Normal")
        {
            timeStuned = 0;
            _view.DefenceAnimFalse();
            _view.HitDefenceAnimFalse();
            actualHits--;
            timeOnDamage = 0.5f;
            if (!onDamage) StartCoroutine(OnDamageCorrutine());
            TakeDamageEvent();
            life -= damage;
            _view.LifeBar(life / maxLife);
            _view.CreatePopText(damage);

            if (!firstHit)
            {
                firstHit = true;
                SendInputToFSM(EnemyInputs.PERSUIT);
                CombatIdleEvent();
            }
        }

        if (!onDefence && typeOfDamage == "Stune")
        {
            StunedEvent();
            actualHits--;
            timeOnDamage = 0.5f;
            if (!onDamage) StartCoroutine(OnDamageCorrutine());        
            life -= damage;
            _view.LifeBar(life / maxLife);
            _view.CreatePopText(damage);
        }


        if (onDefence && angle > 90)
        {
            timeToHoldDefence = 0;
            delayToAttack = 0;
            HitDefenceEvent();
            _view.EndChainAttack();
            _view.HeavyAttackFalse();
            onDefence = false;
        }

        if (life <= 0 && !isDead)
        {
            isDead = true;
            if (cm.times < 2)
            {
                cm.times++;
            }

        }
    }

    public override void MakeDamage()
    {
        var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();

        var desMesh = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>()).Distinct();

        if (player != null)
        {
            damageDone = true;
            _view.WalckBackAnim();
            _view.BackFromAttack();
            var dir = (target.transform.position - transform.position).normalized;
            var angle = Vector3.Angle(dir, target.transform.forward);
            if (player.onDefence && angle >= 90) BlockedEvent();
            player.GetDamage(attackDamage, transform, false, false);
            player.rb.AddForce(transform.forward * 2, ForceMode.Impulse);
        }

        foreach (var item in desMesh)
        {
            item.StartCoroutine(item.startDisolve());
        }
    }

    public void MakeHeavyDamage()
    {
        var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();

        var desMesh = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<DestructibleOBJ>()).Select(x => x.GetComponent<DestructibleOBJ>()).Distinct();

        if (player != null)
        {
            if (player.onDefence)
            {
                _view.sparks.gameObject.SetActive(true);
                _view.sparks.Play();
            }
            player.GetDamage(attackDamage + 5, transform, false, true);
            player.rb.AddForce(transform.forward * 2, ForceMode.Impulse);
        }

        foreach (var item in desMesh)
        {
            item.StartCoroutine(item.startDisolve());
        }
    }


    public override void RemoveNearEntity(EnemyEntity e)
    {
        e.nearEntities.Remove(this);
    }

    public void RemoveWarriorFriend(ModelE_Melee e)
    {
        e.myWarriorFriends.Remove(this);
    }

    public override CombatNode FindNearAggressiveNode()
    {
        var node = playerNodes.Where(x => x.aggressive && !x.isBusy && (x.myOwner == null || x.myOwner == this)).Where(x => {

            var nearNodes = Physics.OverlapSphere(x.transform.position, distanceToHit).Where(y=> y.GetComponent<CombatNode>() && y!=x).Select(y => y.GetComponent<CombatNode>());

            if (nearNodes.Any(y => y.myOwner != this)) return true;

            else return false;

        })
        .OrderBy(x =>
        {
            var d = Vector3.Distance(x.transform.position, transform.position);
            return d;

        }).FirstOrDefault();

        myCombatNode = node;

        myCombatNode.myOwner = this;

        if (lastCombatNode == null)
        {
            lastCombatNode = node;
            lastCombatNode.myOwner = this;
        }

        if (myCombatNode != lastCombatNode)
        {
            lastCombatNode.myOwner = null;
            lastCombatNode = myCombatNode;
        }

        var NearNodes = Physics.OverlapSphere(myCombatNode.transform.position, distanceToHit).Where(y => y.GetComponent<CombatNode>()).Select(y => y.GetComponent<CombatNode>()).Where(y => y.myOwner == null);

        foreach (var item in NearNodes)
        {
            item.myOwner = this;
        }

        if (NearNodes.Count() > 0)
        {

            var restOfNodes = new List<CombatNode>();

            restOfNodes.AddRange(playerNodes);

            restOfNodes.RemoveAll(y => NearNodes.Contains(y));

            foreach (var item in restOfNodes)
            {
                if (item.myOwner == this) item.myOwner = null;
            }

        }

        return node;
    }

    public override CombatNode FindNearNon_AggressiveNode()
    {
        var node = playerNodes.Where(x => x.Non_Aggressive && !x.isBusy && (x.myOwner == null || x.myOwner == this)).OrderBy(x =>
        {
            var d = Vector3.Distance(x.transform.position, transform.position);
            return d;

        }).FirstOrDefault();

        myCombatNode = node;

        myCombatNode.myOwner = this;

        if (lastCombatNode == null)
        {
            lastCombatNode = node;
            lastCombatNode.myOwner = this;
        }

        if (myCombatNode != lastCombatNode)
        {
            lastCombatNode.myOwner = null;
            lastCombatNode = myCombatNode;
        }

        var NearNodes = Physics.OverlapSphere(myCombatNode.transform.position, distanceToHit).Where(y => y.GetComponent<CombatNode>()).Select(y => y.GetComponent<CombatNode>()).Where(y => y.myOwner == null);

        foreach (var item in NearNodes)
        {
            item.myOwner = this;
        }

        if (NearNodes.Count() > 0)
        {

            var restOfNodes = new List<CombatNode>();

            restOfNodes.AddRange(playerNodes);

            restOfNodes.RemoveAll(y => NearNodes.Contains(y));

            foreach (var item in restOfNodes)
            {
                if (item.myOwner == this) item.myOwner = null;
            }

        }

        return node;
    }

    public void StopRetreat()
    {
        cm.times++;
        firstAttack = false;
        onRetreat = false;
        timeToAttack = false;
        _view._anim.SetBool("WalkBack", false);
        if (myWarriorFriends.Count > 0) StartCoroutine(DelayTurn());
        else checkTurn = false;
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<CombatNode>() && isWaitArea) c.GetComponent<CombatNode>().myOwner = this;
    }

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<CombatNode>() && isWaitArea) c.GetComponent<CombatNode>().myOwner = this;
    }

    public void OnTriggerExit(Collider c)
    {
        if (c.GetComponent<CombatNode>() && isWaitArea) c.GetComponent<CombatNode>().myOwner = null;
    }
}
