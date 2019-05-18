using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelE_Melee : EnemyEntity
{

    public enum EnemyInputs { PATROL, PERSUIT, WAIT, ATTACK, RETREAT , FOLLOW, DIE, ANSWER, DEFENCE, REPOSITION }
    public EventFSM<EnemyInputs> _myFsm;
    public List<CombatNode> restOfNodes = new List<CombatNode>();
    public float timeToPatrol;
    public LayerMask layerPlayer;
    public LayerMask layerObst;
    public LayerMask layerEntites;
    public LayerMask layerAttack;
    public bool timeToAttack;
    public EnemyCombatManager cm;
    public List<ModelE_Melee> myWarriorFriends = new List<ModelE_Melee>();
    public Transform attackPivot;
    public Vector3 warriorVectAvoidance;
    public Vector3 warriorVectAvoidanceFlank;
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
    bool firstHit;
    bool impulse;
    public int changeRing;
    Vector3 lastPosition;
    Vector3 nearRingPosition;
    public string animClipName;

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

    public IEnumerator FollowCorrutine ()
    {
        pathToTarget.Clear();

        Node start = GetMyNode();
        Node end = GetMyTargetNode();

        var originalPathToTarget = MyBFS.GetPath(start, end, myNodes);
        originalPathToTarget.Remove(start);
        pathToTarget.AddRange(originalPathToTarget);
        currentIndex = pathToTarget.Count;
        yield return new WaitForSeconds(2);
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

    public void Awake()
    {
        
       
        delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Melee>();
        maxLife = life;
        maxViewDistanceToAttack = viewDistanceAttack;
        actualHits = UnityEngine.Random.Range(hitsToStartDefenceMIN, hitsToStartDefenceMAX);

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

        var patrol = new FSM_State<EnemyInputs>("PATROL");
        var defence = new FSM_State<EnemyInputs>("DEFENCE");
        var persuit = new FSM_State<EnemyInputs>("PERSUIT");
        var wait = new FSM_State<EnemyInputs>("WAIT");
        var attack = new FSM_State<EnemyInputs>("ATTACK");
        var retreat = new FSM_State<EnemyInputs>("RETREAT");
        var die = new FSM_State<EnemyInputs>("DIE");
        var follow = new FSM_State<EnemyInputs>("FOLLOW");
        var answerCall = new FSM_State<EnemyInputs>("ANSWER");
        var reposition = new FSM_State<EnemyInputs>("REPOSITION");

        StateConfigurer.Create(patrol)
           .SetTransition(EnemyInputs.PERSUIT, persuit)
           .SetTransition(EnemyInputs.ANSWER, answerCall)
           .SetTransition(EnemyInputs.WAIT, wait)
           .SetTransition(EnemyInputs.DIE, die)
           .Done();

        StateConfigurer.Create(persuit)
         .SetTransition(EnemyInputs.WAIT, wait)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(wait)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.DEFENCE, defence)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(retreat)
       .SetTransition(EnemyInputs.PERSUIT, persuit)
       .SetTransition(EnemyInputs.FOLLOW, follow)
       .SetTransition(EnemyInputs.WAIT, wait)
       .SetTransition(EnemyInputs.REPOSITION, reposition)
       .SetTransition(EnemyInputs.DEFENCE, defence)
       .SetTransition(EnemyInputs.DIE, die)
       .Done();


        StateConfigurer.Create(reposition)
       .SetTransition(EnemyInputs.WAIT, wait)
       .Done();

        StateConfigurer.Create(attack)
        .SetTransition(EnemyInputs.PERSUIT, persuit)
        .SetTransition(EnemyInputs.DEFENCE, defence)
        .SetTransition(EnemyInputs.FOLLOW, follow)
        .SetTransition(EnemyInputs.WAIT, wait)
        .SetTransition(EnemyInputs.RETREAT, retreat)
        .SetTransition(EnemyInputs.DIE, die)
        .Done();


        StateConfigurer.Create(follow)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.WAIT, wait)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(defence)
           .SetTransition(EnemyInputs.PERSUIT, persuit)
           .SetTransition(EnemyInputs.ATTACK, attack)
           .SetTransition(EnemyInputs.WAIT, wait)
           .SetTransition(EnemyInputs.FOLLOW, follow)
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
            PersuitState = true;

            _view._anim.SetBool("WalkBack", false);

            if (!onDamage) CombatWalkEvent();

            isAnswerCall = false;

            firstSaw = true;

            if(timeToAttack && !onDamage) delayToAttack -= Time.deltaTime; 

            if(timeToAttack && onDamage) delayToAttack -= Time.deltaTime * 2; 

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            currentAction = new A_Persuit(this);

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (isWaitArea) SendInputToFSM(EnemyInputs.WAIT);

            if (!isDead && d > viewDistancePersuit) SendInputToFSM(EnemyInputs.FOLLOW);

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

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (!isDead && d > viewDistancePersuit && !onRetreat && timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && !isWaitArea && isPersuit && timeToHoldDefence<=0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && delayToAttack <= 0 && timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && isWaitArea && timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        defence.OnExit += x =>
        {
            actualHits = UnityEngine.Random.Range(hitsToStartDefenceMIN, hitsToStartDefenceMAX);

            onDefence = false;

            _view.DefenceAnimFalse();
        };

        wait.OnEnter += x =>
        {
            if (!timeToAttack) delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);

            _view._anim.SetBool("WalkBack", false);
            firstAttack = false;
            onRetreat = false;

            if (aggressiveLevel == 1) viewDistanceAttack = 4.5f;

            timeToChangeRotation = UnityEngine.Random.Range(1.5f, 3);

            /* var restOfNodes = new List<CombatNode>();

             restOfNodes.AddRange(playerNodes);

             restOfNodes.RemoveAll(y => NearNodes.Contains(y));

             foreach (var item in restOfNodes)
             {
                 if (item.myOwner == this) item.myOwner = null;
             }

             /* int r = UnityEngine.Random.Range(0, 2);

              flankDir = r;

              if(!timeToAttack) delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);

              _view._anim.SetBool("WalkBack", false);
              firstAttack = false;
              onRetreat = false;
              //timeToAttack = false;
              */
        };

     
        wait.OnUpdate += () =>
        {
            WaitState = true;

            timeToChangeRotation -= Time.deltaTime;

            if(timeToChangeRotation <=0 && changeRotateWarrior)
            {
                timeToChangeRotation = UnityEngine.Random.Range(0.5f, 1.5f);
                changeRotateWarrior = false;
            }

            if (timeToChangeRotation <= 0 && !changeRotateWarrior)
            {
                bool left = false;
                bool right = false;

                foreach (var item in myWarriorFriends)
                {
                    var relativePoint = transform.InverseTransformPoint(item.transform.position);

                    if (relativePoint.x < 0.0) left = true;
 
                    if (relativePoint.x > 0.0) right = true;                  
                }

                if (left && !right) flankDir = 0; 

                if (!left && right) flankDir = 1; 

                if (!left && !right) flankDir = 2; 
           
                timeToChangeRotation = UnityEngine.Random.Range(2, 3);
                changeRotateWarrior = true;
            }

            var NearNodes = Physics.OverlapSphere(transform.position, distanceToHit).Where(y => y.GetComponent<CombatNode>()).Select(y => y.GetComponent<CombatNode>()).Where(y => y.myOwner == null);

            foreach (var item in NearNodes)
            {
                item.myOwner = this;
            }

            if (NearNodes.Count() > 0)
            {

                restOfNodes = new List<CombatNode>();

                restOfNodes.AddRange(playerNodes);

                restOfNodes.RemoveAll(y => NearNodes.Contains(y));

                foreach (var item in restOfNodes)
                {
                    if (item.myOwner == this) item.myOwner = null;
                }

            }

            currentAction = new A_WarriorWait(this, flankDir);

            WaitState = true;

            if (timeToAttack) delayToAttack -= Time.deltaTime;

            if (timeToAttack && onDamage) delayToAttack -= Time.deltaTime * 2;

            angleToAttack = 110;

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!isDead && !isWaitArea && isPersuit && !onDefence) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isWaitArea && !isPersuit && !onDefence) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && delayToAttack <= 0 && !onDefence) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        wait.OnExit += x =>
        {
            WaitState = false;
        };

        attack.OnEnter += x =>
        {
            delayToAttack = 0;
            onRetreat = false;
            firstAttack = false;

          /*  if (NearCombatRing().name == "Ring1") timeToRetreat = 0.5f;
            if (NearCombatRing().name == "Ring2") timeToRetreat = 1f;
            if (NearCombatRing().name == "Ring3") timeToRetreat = 1.3f;
            */
            damageDone = false;
        };

        attack.OnFixedUpdate += () =>
        {
            AttackState = true;

            currentAction = new A_AttackMeleeWarrior(this);

            isAnswerCall = false;

            firstSaw = true;

            var d = Vector3.Distance(transform.position, target.transform.position);

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!isDead && !isWaitArea && isPersuit && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && d > viewDistancePersuit && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.FOLLOW);

            if (onRetreat && !onDefence) SendInputToFSM(EnemyInputs.RETREAT);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (isDead ) SendInputToFSM(EnemyInputs.DIE);


        };

        attack.OnExit += x =>
        {
            AttackState = false;
        };


        retreat.OnEnter += x =>
        {
            //distanceRetreat = Vector3.Distance(transform.position, target.transform.position);
            if (aggressiveLevel == 1) timeToRetreat = 1.5f;
        };

        retreat.OnFixedUpdate += () =>
        {
            RetreatState = true;

            currentAction = new A_WarriorRetreat(this);

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (!isDead && isPersuit && !isWaitArea && timeToRetreat <= 0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && d > viewDistancePersuit && timeToRetreat <= 0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (!isDead && isWaitArea && timeToRetreat <=0) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        retreat.OnUpdate += () =>
        {
            if (animClipName != "E_Warrior_Attack1" && animClipName != "E_Warrior_Attack2" && animClipName != "E_Warrior_Attack3" && animClipName != "Heavy Attack_EM" && animClipName != "Run_EM" && animClipName != "HitDefence") timeToRetreat -= Time.deltaTime;

        };

        retreat.OnExit += x =>
        {
            RetreatState = false;
            StopRetreat();
        };

        follow.OnEnter += x =>
        {

            StartCoroutine(FollowCorrutine());

        };

        follow.OnUpdate += () =>
        {
            FollowsState = true;

            var d = Vector3.Distance(transform.position, target.transform.position);

            currentAction = new A_FollowTarget(this);

            if (!onDamage) CombatWalkEvent();

            if (!isDead && d < viewDistancePersuit) SendInputToFSM(EnemyInputs.PERSUIT);
        };

        follow.OnExit += x => 
        {
            FollowsState = true;
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

        FillFriends();

        warriorVectAvoidance = WarriorAvoidance();
        warriorVectAvoidanceFlank = WarriorAvoidanceFlank();
        avoidVectObstacles = ObstacleAvoidance();
        entitiesAvoidVect = EntitiesAvoidance();

        if (target != null)
        {
           
            if (!onAttackArea && SearchForTarget.SearchTarget(target.transform, viewDistancePersuit, angleToPersuit, transform, true, layerObst)) isPersuit = true;
            else isPersuit = false;

            if (!onAttackArea && SearchForTarget.SearchTarget(target.transform, viewDistanceAttack, angleToAttack, transform, true, layerObst)) isWaitArea = true;
            else isWaitArea = false;

            if (SearchForTarget.SearchTarget(target.transform, distanceToHit, angleToHit, transform, true, layerObst)) onAttackArea = true;
            else onAttackArea = false;

        }

        if (onDamage)
        {
            timeOnDamage -= Time.deltaTime;
            if (timeOnDamage <= 0)
            {
                onDamage = false;
            }
        }

        if (life <= 0)
        {
            isDead = true;
            SendInputToFSM(EnemyInputs.DIE);
        }

        if ((_view._anim.GetBool("Attack") || _view._anim.GetBool("Attack2") || _view._anim.GetBool("Attack3") || _view._anim.GetBool("HeavyAttack")) && !isDead && !onDefence)
        {
            transform.LookAt(target.transform.position);
        }

        
        if (animClipName != "E_Warrior_Attack1" && animClipName != "E_Warrior_Attack2" && animClipName != "E_Warrior_Attack3") impulse = false;

        if (impulse && (animClipName == "E_Warrior_Attack1" || animClipName == "E_Warrior_Attack2" || animClipName == "E_Warrior_Attack3")) transform.position += transform.forward * 2 * Time.deltaTime;
                   
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
       var obs = Physics.OverlapSphere(transform.position, 1, layerObst).Where(x=> !x.GetComponent<Model>());
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
                                        .Select(x => x.GetComponent<ModelE_Melee>()));
        myWarriorFriends.Remove(this);
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
        var obs = Physics.OverlapSphere(transform.position, 2, layerEntites);
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public  Vector3 WarriorAvoidanceFlank()
    {
        var obs = Physics.OverlapSphere(transform.position, 1, layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>());
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public Vector3 WarriorAvoidance()
    {
        var obs = Physics.OverlapSphere(transform.position, 1, layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>());
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

    public override void GetDamage(float damage)
    {
        Vector3 dir = transform.position - target.transform.position;
        float angle = Vector3.Angle(dir, transform.forward);
        impulse = false;

        if (onDefence && angle > 90)
        {
            timeToHoldDefence = 0;
            delayToAttack = 0;
            HitDefenceEvent();
            if (!_view._anim.GetBool("HeavyAttack") && !_view._anim.GetBool("Attack")) SendInputToFSM(EnemyInputs.ATTACK);           
        }

        if (!onDefence)
        {
            _view.DefenceAnimFalse();
            _view.HitDefenceAnimFalse();
            actualHits--;
            timeOnDamage = 0.5f;
            if (!onDamage) onDamage = true;     
            TakeDamageEvent();
            life -= damage;
            _view.LifeBar(life / maxLife);
            _view.CreatePopText(damage);

            if (life <= 0 && !isDead)
            {
                isDead = true;
                if (cm.times < 2)
                {
                    cm.times++;
                }

            }

            if (!firstHit)
            {
                firstHit = true;
                SendInputToFSM(EnemyInputs.PERSUIT);
                CombatIdleEvent();
            }
        }
    }

    public override void MakeDamage()
    {
        var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();
        if (player != null)
        {
            damageDone = true;
            timeToRetreat += 0.25f;
            _view.WalckBackAnim();
            _view.BackFromAttack();
            var dir = (target.transform.position - transform.position).normalized;
            var angle = Vector3.Angle(dir, target.transform.forward);
            if (player.onDefence && angle >= 90) BlockedEvent();
            player.GetDamage(attackDamage, transform, false, false);
        }
    }

    public void MakeHeavyDamage()
    {
        var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();
        if (player != null)
        {
            timeToRetreat += 0.25f;
            _view.WalckBackAnim();
            _view.HeavyAttackFalse();
            if (player.onDefence)
            {
                _view.sparks.gameObject.SetActive(true);
                _view.sparks.Play();
            }
            player.GetDamage(attackDamage + 5, transform, false, true);          
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
        var node = playerNodes.Where(x => x.aggressive && !x.isBusy && (x.myOwner == null || x.myOwner == this)).OrderBy(x =>
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

        if(myCombatNode != lastCombatNode)
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
