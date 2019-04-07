using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelE_Melee : EnemyEntity
{

    public enum EnemyInputs { PATROL, PERSUIT, WAIT, ATTACK, RETREAT , FOLLOW, DIE, ANSWER }
    public EventFSM<EnemyInputs> _myFsm;
    public float timeToPatrol;
    public LayerMask layerPlayer;
    public LayerMask layerObst;
    public LayerMask layerEntites;
    public LayerMask layerAttack;
    public bool timeToAttack;
    public bool flank;
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
    public bool flankSpeed;
    public bool testEnemy;
    bool firstHit;
    bool impulse;
    Vector3 lastPosition;

    public Action TakeDamageEvent;
    public Action DeadEvent;
    public Action AttackEvent;
    public Action MoveEvent;
    public Action IdleEvent;
    public Action BlockedEvent;

    float maxLife;
    public float timeToRetreat;

    public IEnumerator Resting()
    {
       //if (myWarriorFriends.Count < 0) timeToAttack = false;
       onAttack = true;
       yield return new WaitForSeconds(2);
       //timeToAttack = false;      
       onAttack = false;
       firstAttack = false;
    }

    public IEnumerator Retreat()
    {
        onRetreat = true;
        yield return new WaitForSeconds(1f);
        onRetreat = false;
        delayToAttack = UnityEngine.Random.Range(2,5);
        maxDelayToAttack = delayToAttack;
    }
 
    public IEnumerator Delay( float time)
    {
        checkTurn = false;
        yield return new WaitForSeconds(time);
        StartCoroutine(Retreat());
    }

    public void Awake()
    {
        delayToAttack = UnityEngine.Random.Range(1f, 2f);
        maxDelayToAttack = delayToAttack;
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Melee>();
        maxLife = life;

        TakeDamageEvent += _view.TakeDamageAnim;
        DeadEvent += _view.DeadAnim;
        AttackEvent += _view.AttackAnim;
        IdleEvent += _view.IdleAnim;
        MoveEvent += _view.BackFromIdle;
        BlockedEvent += _view.BlockedAnim;


        var patrol = new FSM_State<EnemyInputs>("PATROL");
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
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

         StateConfigurer.Create(retreat)
        .SetTransition(EnemyInputs.PERSUIT, persuit)
        .SetTransition(EnemyInputs.FOLLOW, follow)
        .SetTransition(EnemyInputs.WAIT, wait)
        .SetTransition(EnemyInputs.DIE, die)
        .Done();

        StateConfigurer.Create(attack)
        .SetTransition(EnemyInputs.PERSUIT, persuit)
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

            if ((!isDead && isPersuit && !isAttack) && onDamage) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAnswerCall) SendInputToFSM(EnemyInputs.ANSWER);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        patrol.OnUpdate += () =>
        {
            timeToPatrol -= Time.deltaTime;
        };

        patrol.OnExit += x =>
        {
            angleToPersuit = 180;
            angleToAttack = 180;
        };
     
        answerCall.OnFixedUpdate += () =>
        {

            currentAction = new A_FollowTarget(this);
            MoveEvent();
            if (!isDead && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.WAIT);
        };

     
        persuit.OnFixedUpdate += () =>
        {
          
            if (!onDamage) MoveEvent();

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            currentAction = new A_Persuit(this);

            if(!isDead && isAttack) SendInputToFSM(EnemyInputs.WAIT);

            if (!isDead && !isAttack && !isPersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        wait.OnEnter += x =>
        {
            int r = UnityEngine.Random.Range(0, 1);
            if (r <1) flankSpeed = true;
            if (r >= 1) flankSpeed = false;

            delayToAttack = UnityEngine.Random.Range(1f, 2f);

        };

        wait.OnUpdate += () => 
        {

            if (timeToAttack) delayToAttack -= Time.deltaTime;
            
            angleToAttack = 110;

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            currentAction = new A_WarriorWait(this);

            if (!isDead && !isAttack && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && delayToAttack <= 0) SendInputToFSM(EnemyInputs.ATTACK);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };
      
        attack.OnFixedUpdate += () =>
        {

            currentAction = new A_AttackMeleeWarrior(this);

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!isDead && !isAttack && isPersuit  && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isAttack && !isPersuit  && !onRetreat) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && delayToAttack>0 && !onRetreat) SendInputToFSM(EnemyInputs.WAIT);

            if (onRetreat) SendInputToFSM(EnemyInputs.RETREAT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

            
        };

        retreat.OnEnter += x =>
        {
            timeToRetreat = UnityEngine.Random.Range(2, 3);
        };

        retreat.OnFixedUpdate += () =>
        {
            Debug.Log("retreat");
            currentAction = new A_WarriorRetreat(this);

            if (!isDead && !isAttack && isPersuit  && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isAttack && !isPersuit  && !onRetreat) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead  && !onRetreat) SendInputToFSM(EnemyInputs.WAIT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        retreat.OnUpdate += () =>
        {
            timeToRetreat -= Time.deltaTime;
        };

        follow.OnEnter += x =>
        {
            Node start = GetMyNode();
            Node end = GetMyTargetNode();

            pathToTarget = MyBFS.GetPath(start, end, myNodes);
            currentIndex = pathToTarget.Count;

            angleToPersuit = 180;
        };

        follow.OnExit += x =>
        {            
            angleToPersuit = 90;
        };

        follow.OnUpdate += () =>
        {

            currentAction = new A_FollowTarget(this);

            if (!onDamage) MoveEvent();

            if (!isDead && !isAttack && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.WAIT);
        };

        die.OnEnter += x =>
        {
            DeadEvent();
            currentAction = null;

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
            
            if(nearEntities.Count <=0)
            {
                target.timeOnCombat = 0;
                target.isInCombat = false;
            }

            ca.myEntities--;
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

        if (target != null  && !isAttack && !onAttackArea && SearchForTarget.SearchTarget(target.transform, viewDistancePersuit, angleToPersuit, transform, true, layerObst)) isPersuit = true;
        else isPersuit = false;

        if (target != null  && !onAttackArea && SearchForTarget.SearchTarget(target.transform, viewDistanceAttack, angleToAttack, transform, true, layerObst)) isAttack = true;
        else isAttack = false;

        if (target != null && SearchForTarget.SearchTarget(target.transform, distanceToHit, angleToHit , transform, true, layerObst)) onAttackArea = true;
        else onAttackArea = false;

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

        if (_view._anim.GetBool("Attack"))
        {
            transform.LookAt(target.transform.position);
        }

        if(impulse)
        {
            transform.position = Vector3.Lerp(lastPosition, transform.position + transform.forward * 2 * Time.deltaTime, 2);
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
        var obs = Physics.OverlapSphere(transform.position, 1, layerEntites).Where(x=> x.GetComponent<ModelE_Melee>()).Select(x=> x.GetComponent<ModelE_Melee>()).Where(x => x.flank);
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public Vector3 WarriorAvoidance()
    {
        var obs = Physics.OverlapSphere(transform.position, 1, layerEntites).Where(x => x.GetComponent<ModelE_Melee>()).Select(x => x.GetComponent<ModelE_Melee>()).Where(x => !x.flank);
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
        
        if (!firstHit)
        {
            firstHit = true;
            SendInputToFSM(EnemyInputs.PERSUIT);
        }
        
        delayToAttack += 0.25f;
        timeOnDamage = 1;
        if (!onDamage) onDamage = true;
        if (delayToAttack >= maxDelayToAttack) delayToAttack = maxDelayToAttack;
        TakeDamageEvent();      
        life -= damage;
        _view.LifeBar(life / maxLife);

        if (life <= 0 && !isDead)
        {
            isDead = true;
            if (cm.times < 2)
            {
                cm.times++;
            }
           
            if (flank)
            {
                cm.flanTicket = false;
                flank = false;
            } 
        }
    }

    public override void MakeDamage()
    {
        checkTurn = false;

        var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();
        if (player != null)
        {
           // cm.times++;
            var dir = (target.transform.position - transform.position).normalized;
            var angle = Vector3.Angle(dir, target.transform.forward);

            if (player.onDefence && angle >= 90) BlockedEvent();
            player.GetDamage(attackDamage, transform, false);
        }
    }

    public override void RetreatTrue()
    {
        throw new NotImplementedException();
    }

    public override void OnDamageFalse()
    {
        throw new NotImplementedException();
    }

    public override void RemoveNearEntity(EnemyEntity e)
    {
        e.nearEntities.Remove(this);
    }

    public void RemoveWarriorFriend(ModelE_Melee e)
    {
        e.myWarriorFriends.Remove(this);
    }
}
