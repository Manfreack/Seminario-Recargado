using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelE_Melee : EnemyEntity
{

    public enum EnemyInputs { PATROL, PERSUIT, WAIT, ATTACK, RETREAT , FOLLOW, DIE, ANSWER, DEFENCE }
    public EventFSM<EnemyInputs> _myFsm;
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
    public bool onAttackArea;
    public bool firstAttack;
    public bool checkTurn;
    public bool changeRotateWarrior;
    public bool onDefence;
    public int flankDir;
    public bool testEnemy;
    bool firstHit;
    bool impulse;
    Vector3 lastPosition;
    

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

    float maxLife;
    public float timeToRetreat;
    public float startRetreat;
    float maxViewDistanceToAttack;
    Vector3 vectoToNodeRetreat;

    [Header("Enemy Combat:")]

    public float timeMinAttack;
    public float timeMaxAttack;
    public float timeStartImpulse;
    public float timeEndImpulse;
    public float impulseStart;
    public float impulseEnd;
    public float timeToHoldDefence;
    public float maxTimeToDefence;
    public float hitsToStartDefenceMAX;
    public float hitsToStartDefenceMIN;
    public float actualHits;

    public IEnumerator RetreatCorrutine()
    {
        yield return new WaitForSeconds(0.5f);
        onRetreat = true;
    }

    public IEnumerator DelayTurn()
    {
        checkTurn = true;
        yield return new WaitForSeconds(2);
        checkTurn = false;

    }

    public IEnumerator DelayChangeDir()
    {
        changeRotateWarrior = false;
        yield return new WaitForSeconds(1);
        changeRotateWarrior = true;
    }

    public void Awake()
    {
        playerNodes.AddRange(FindObjectsOfType<CombatNode>());
        delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);
        maxDelayToAttack = delayToAttack;
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Melee>();
        maxLife = life;
        maxViewDistanceToAttack = viewDistanceAttack;
        actualHits = UnityEngine.Random.Range(hitsToStartDefenceMIN, hitsToStartDefenceMAX);

        TakeDamageEvent += _view.TakeDamageAnim;
        DeadEvent += _view.DeadAnim;
        AttackEvent += _view.AttackAnim;
        HeavyAttackEvent += _view.HeavyAttackAnim;
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
       .SetTransition(EnemyInputs.DEFENCE, defence)
       .SetTransition(EnemyInputs.DIE, die)
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

            if ((!isDead && isPersuit && !isAttack && !target.view.startFade.enabled) || onDamage) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAnswerCall) SendInputToFSM(EnemyInputs.ANSWER);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.WAIT);

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

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };


        persuit.OnFixedUpdate += () =>
        {
            Debug.Log("persuit");

            if (!onDamage) CombatWalkEvent();

            isAnswerCall = false;

            firstSaw = true;

            if(timeToAttack) delayToAttack -= Time.deltaTime;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            currentAction = new A_Persuit(this);

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (actualRing != null)
            {
                if (actualRing.nextRing != null)
                {

                    if (!isDead && actualRing.nextRing.myEnemies.Count > actualRing.nextRing.entityMaxAmount)
                    {
                        SendInputToFSM(EnemyInputs.WAIT);
                    }
                }

                else
                {
                    SendInputToFSM(EnemyInputs.WAIT);
                }
            }

            if (!isDead && d > viewDistancePersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
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

            if (!isDead && !isAttack && isPersuit && timeToHoldDefence<=0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && delayToAttack <= 0 && timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && isAttack && timeToHoldDefence <= 0) SendInputToFSM(EnemyInputs.WAIT);

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
            if (actualRing != null)
            {
                if (actualRing.name == "Ring1") viewDistanceAttack = 4.52f;
                if (actualRing.name == "Ring2") viewDistanceAttack = 6;
                if (actualRing.name == "Ring3") viewDistanceAttack = 8;
            }

            int r = UnityEngine.Random.Range(0, 2);

            flankDir = r;

            if(!timeToAttack) delayToAttack = UnityEngine.Random.Range(timeMinAttack, timeMaxAttack);

        };

     
        wait.OnUpdate += () =>
        {
            Debug.Log("wait");

            var dir = (target.transform.position - transform.position).normalized;

            if (timeToAttack) delayToAttack -= Time.deltaTime;

            angleToAttack = 110;

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            currentAction = new A_WarriorWait(this , flankDir);

            if (!isDead && !isAttack && isPersuit && !onDefence) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && delayToAttack <= 0 && !onDefence) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && actualHits<=0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
            
        };

        attack.OnFixedUpdate += () =>
        {
            currentAction = new A_AttackMeleeWarrior(this);

            isAnswerCall = false;

            firstSaw = true;

            var d = Vector3.Distance(transform.position, target.transform.position);

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!isDead && !isAttack && isPersuit && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && d > viewDistancePersuit && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && delayToAttack > 0 && !onRetreat && !onDefence) SendInputToFSM(EnemyInputs.WAIT);

            if (onRetreat && !onDefence) SendInputToFSM(EnemyInputs.RETREAT);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (isDead ) SendInputToFSM(EnemyInputs.DIE);


        };

        retreat.OnEnter += x =>
        {
            startRetreat = 0.3f;
            if(actualRing.name == "Ring1") timeToRetreat = 0.5f;         
            if(actualRing.name == "Ring2") timeToRetreat = 1f;         
            if(actualRing.name == "Ring3") timeToRetreat = 1.3f;         
            vectoToNodeRetreat = (FindNearCombatNode().transform.position - transform.position).normalized;
            vectoToNodeRetreat.y = 0;
            viewDistanceAttack = 1;
        };

        retreat.OnFixedUpdate += () =>
        {

            currentAction = new A_WarriorRetreat(this, vectoToNodeRetreat);

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (!isDead && isPersuit && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && d > viewDistancePersuit && !onRetreat) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && actualHits <= 0) SendInputToFSM(EnemyInputs.DEFENCE);

            if (!isDead && actualRing != null && timeToRetreat <=0) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        retreat.OnUpdate += () =>
        {
            if ( startRetreat <= 0) timeToRetreat -= Time.deltaTime;

            if(_view._anim.GetBool("Attack") == false && _view._anim.GetBool("HeavyAttack") == false) startRetreat -= Time.deltaTime;

        };

        follow.OnEnter += x =>
        {
            pathToTarget.Clear();
            
            Node start = GetMyNode();
            Node end = GetMyTargetNode();

            var originalPathToTarget = MyBFS.GetPath(start, end, myNodes);
            originalPathToTarget.Remove(start);
            pathToTarget.AddRange(originalPathToTarget);
            currentIndex = pathToTarget.Count;

        };

        follow.OnUpdate += () =>
        {
            Debug.Log("follow");

            var d = Vector3.Distance(transform.position, target.transform.position);

            currentAction = new A_FollowTarget(this);

            if (!onDamage) CombatWalkEvent();

            if (!isDead && d < viewDistancePersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && actualRing != null) SendInputToFSM(EnemyInputs.WAIT);
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

    private void Update()
    {
        _myFsm.Update();

        FillFriends();

        warriorVectAvoidance = WarriorAvoidance();
        warriorVectAvoidanceFlank = WarriorAvoidanceFlank();
        avoidVectObstacles = ObstacleAvoidance();
        entitiesAvoidVect = EntitiesAvoidance();

        if (target != null)
        {

            if (!isAttack && !onAttackArea && SearchForTarget.SearchTarget(target.transform, viewDistancePersuit, angleToPersuit, transform, true, layerObst)) isPersuit = true;
            else isPersuit = false;

            if (!onAttackArea && SearchForTarget.SearchTarget(target.transform, viewDistanceAttack, angleToAttack, transform, true, layerObst)) isAttack = true;
            else isAttack = false;

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

        if (_view._anim.GetBool("Attack") && !isDead)
        {
            transform.LookAt(target.transform.position);
        }


        impulseStart -= Time.deltaTime;
   
        if (impulseStart < 0)
        {
            impulseEnd -= Time.deltaTime;
            if (impulseEnd > 0)
            {
                transform.position += transform.forward * 2 * Time.deltaTime;
            }
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
       var obs = Physics.OverlapSphere(transform.position, 2, layerObst).Where(x=> !x.GetComponent<Model>());
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

        if (onDefence && angle > 90)
        {
            timeToHoldDefence = 0;
            if (timeToAttack) delayToAttack = 0;
            HitDefenceEvent();
        }

        if (!onDefence)
        {
            _view.DefenceAnimFalse();
            _view.HitDefenceAnimFalse();
            impulseStart = 0.6f;
            actualHits--;
            impulseEnd = timeEndImpulse;
            timeToRetreat = startRetreat;
            timeOnDamage = 0.5f;
            delayToAttack -= 0.5f;
            if (!onDamage) onDamage = true;
            if (delayToAttack >= maxDelayToAttack) delayToAttack = maxDelayToAttack;
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
            var dir = (target.transform.position - transform.position).normalized;
            var angle = Vector3.Angle(dir, target.transform.forward);
            player.onDefence = false;
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

    public override CombatNode FindNearCombatNode()
    {
        var node = playerNodes.Where(x => !x.isBusy && x.meleeNode).OrderBy(x =>
         {
             var d = Vector3.Distance(x.transform.position, transform.position);
             return d;
         }).First();

        return node;
    }

    public void StopRetreat()
    {     
       cm.times++;
       firstAttack = false;
       onRetreat = false;
       timeToAttack = false;
       StartCoroutine(DelayTurn());      
    }

    public void OnTriggerStay(Collider c)
    {
        if (c.GetComponent<Ring>()) actualRing = c.GetComponent<Ring>().parent;
    }

    public void OnTriggerEnter(Collider c)
    {
        if (c.GetComponent<Ring>()) actualRing = c.GetComponent<Ring>().parent;
    }
}
