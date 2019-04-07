using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelE_Sniper : EnemyEntity
{
    public enum EnemyInputs { PATROL, PERSUIT, ATTACK, MELEE_ATTACK, FOLLOW, DIE, ANSWER, RETREAT }
    private EventFSM<EnemyInputs> _myFsm;
    public LayerMask layerObst;
    public LayerMask layerEntites;
    public LayerMask layerPlayer;
    ViewerE_Sniper _view;
    public Transform attackPivot;
    public float timeToShoot;
    public EnemyAmmo munition;
    public float distanceToMeleeAttack;
    public float angleToMeleeAttack;
    public bool onMeleeAttack;
    public float timeToMeleeAttack;
    public bool cooldwonToGoBack;
    

    public Action TakeDamageEvent;
    public Action DeadEvent;
    public Action AttackEvent;
    public Action AttackMeleeEvent;
    public Action MoveEvent;
    public Action IdleEvent;
	
	public float maxLife;

    public IEnumerator RotateToTarget()
    {
         yield return new WaitForSeconds(1);
         timeToStopBack = UnityEngine.Random.Range(3, 4);
         onRetreat = false;
         StartCoroutine(Cooldwon());
    }

    public IEnumerator Cooldwon()
    {
        cooldwonToGoBack = true;
        yield return new WaitForSeconds(15);
        cooldwonToGoBack = false;
    }

    public void Awake()
    {
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Sniper>();
        munition = FindObjectOfType<EnemyAmmo>();
        timeToShoot = UnityEngine.Random.Range(2, 4);
        timeToMeleeAttack = UnityEngine.Random.Range(2, 4);
        timeToStopBack = UnityEngine.Random.Range(3, 4);
		maxLife = life;

        var patrol = new FSM_State<EnemyInputs>("PATROL");
        var persuit = new FSM_State<EnemyInputs>("PERSUIT");
        var attack = new FSM_State<EnemyInputs>("ATTACK");
        var melee_attack = new FSM_State<EnemyInputs>("MELEE_ATTACK");
        var die = new FSM_State<EnemyInputs>("DIE");
        var follow = new FSM_State<EnemyInputs>("FOLLOW");
        var answerCall = new FSM_State<EnemyInputs>("ANSWER");
        var retreat = new FSM_State<EnemyInputs>("RETREAT");

        TakeDamageEvent += _view.TakeDamageAnim;
        DeadEvent += _view.DeadAnim;
        AttackEvent += _view.AttackRangeAnim;
        AttackMeleeEvent += _view.AttackMeleeAnim;
        IdleEvent += _view.IdleAnim;
        MoveEvent += _view.BackFromIdle;

        StateConfigurer.Create(patrol)
           .SetTransition(EnemyInputs.PERSUIT, persuit)
           .SetTransition(EnemyInputs.ANSWER, answerCall)
           .SetTransition(EnemyInputs.ATTACK, attack)
           .SetTransition(EnemyInputs.MELEE_ATTACK, melee_attack)
           .SetTransition(EnemyInputs.FOLLOW, follow)
           .SetTransition(EnemyInputs.DIE, die)
           .Done();

        StateConfigurer.Create(retreat)
          .SetTransition(EnemyInputs.PERSUIT, persuit)
          .SetTransition(EnemyInputs.ATTACK, attack)
          .SetTransition(EnemyInputs.MELEE_ATTACK, melee_attack)
          .SetTransition(EnemyInputs.FOLLOW, follow)
          .SetTransition(EnemyInputs.DIE, die)
          .Done();

        StateConfigurer.Create(persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.MELEE_ATTACK, melee_attack)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(attack)
         .SetTransition(EnemyInputs.MELEE_ATTACK, melee_attack)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(melee_attack)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.RETREAT, retreat)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(follow)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(answerCall)
        .SetTransition(EnemyInputs.PERSUIT, persuit)
        .SetTransition(EnemyInputs.ATTACK, attack)
        .SetTransition(EnemyInputs.DIE, die)
        .Done();

        StateConfigurer.Create(die).Done();

        patrol.OnFixedUpdate += () =>
        {
            currentAction = new A_SniperPatrol(this);

            if (!isDead && isPersuit && !isAttack) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAnswerCall) SendInputToFSM(EnemyInputs.ANSWER);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && onMeleeAttack && onDamage) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && !isAttack && !isPersuit && !onMeleeAttack && onDamage) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        patrol.OnExit += x =>
        {
            angleToPersuit = 180;
        };

        answerCall.OnFixedUpdate += () =>
        {
            angleToPersuit = 180;
            currentAction = new A_FollowTarget(this);
            if (!onDamage) MoveEvent();
            if (!isDead && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.ATTACK);
        };

        persuit.OnFixedUpdate += () =>
        {
            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!onDamage) MoveEvent();

            currentAction = new A_Persuit(this);

            if (!isDead && onMeleeAttack) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && !isAttack && !isPersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        attack.OnUpdate += () =>
        {
            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!onDamage) timeToShoot -= Time.deltaTime;

            currentAction = new A_SniperAttack(this);

            if (!isDead && onMeleeAttack) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && !isAttack && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isAttack && !isPersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };
 
        melee_attack.OnUpdate += () =>
        {
            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!onDamage) timeToMeleeAttack -= Time.deltaTime;
           
            currentAction = new A_SniperMeleeAttack(this);

            if (!isDead && isAttack && !onRetreat) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && !isAttack && isPersuit && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isAttack && !isPersuit && !onRetreat && timeToStopBack<=0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && onRetreat) SendInputToFSM(EnemyInputs.RETREAT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        retreat.OnEnter += x =>
        {
            timeToStopBack = UnityEngine.Random.Range(3, 4);

            List<Vector3> sides = new List<Vector3>();

            RaycastHit hit;

            if (Physics.Raycast(transform.position, -transform.right, out hit, 2)) sides.Remove(-transform.right);
            else sides.Add(-transform.right);

            if (Physics.Raycast(transform.position, transform.right, out hit, 2)) sides.Remove(transform.right); 
            else sides.Add(transform.right);

            if (Physics.Raycast(transform.position, -transform.forward, out hit, 2)) sides.Remove(-transform.forward);
            else sides.Add(-transform.forward);

            if (sides.Count > 0)
            {
                int r = UnityEngine.Random.Range(0, sides.Count - 1);
                positionToBack = sides[r];
            }

            else positionToBack = transform.forward;

             
        };

        retreat.OnUpdate += () =>
        {
            Debug.Log("retreat");

            if (!onDamage) timeToStopBack -= Time.deltaTime;

            currentAction = new A_GoBackFromAttack(this);

            if (!isDead && isPersuit && !isAttack && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAttack && !onRetreat) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && onMeleeAttack && !onRetreat) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && !isAttack && !isPersuit && !onMeleeAttack && !onRetreat) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        follow.OnEnter += x =>
        {
            Node start = GetMyNode();
            Node end = GetMyTargetNode();
        
            pathToTarget = MyBFS.GetPath(start, end, myNodes);
            currentIndex = pathToTarget.Count;
        };


        follow.OnUpdate += () =>
        {
            currentAction = new A_FollowTarget(this);

            if (!onDamage) MoveEvent();

            if (!isDead && !isAttack && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAttack) SendInputToFSM(EnemyInputs.ATTACK);
        };

        die.OnEnter += x =>
        {
            DeadEvent();
            currentAction = null;

            if (nearEntities.Count > 0)
            {
                foreach (var item in nearEntities)
                {
                    RemoveNearEntity(item);
                }
            }

            if (nearEntities.Count <= 0)
            {
                target.timeOnCombat = 0;
                target.isInCombat = false;
            }

            ca.myEntities--;
        };


        _myFsm = new EventFSM<EnemyInputs>(patrol);
    }


    private void SendInputToFSM(EnemyInputs inp)
    {
        _myFsm.SendInput(inp);
    }

    private void Update()
    {
        _myFsm.Update();

        avoidVectObstacles = ObstacleAvoidance();
        entitiesAvoidVect = EntitiesAvoidance();

        if (target != null && !onMeleeAttack && !isAttack && SearchForTarget.SearchTarget(target.transform, viewDistancePersuit, angleToPersuit, transform, true, layerObst)) isPersuit = true;
        else isPersuit = false;

        if (target != null && !onMeleeAttack && SearchForTarget.SearchTarget(target.transform, viewDistanceAttack, angleToAttack, transform, true, layerObst)) isAttack = true;
        else isAttack = false;

        if (target != null && SearchForTarget.SearchTarget(target.transform, distanceToMeleeAttack, angleToMeleeAttack, transform, true, layerObst)) onMeleeAttack = true;
        else onMeleeAttack = false;

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
    }

    private void FixedUpdate()
    {
        _myFsm.FixedUpdate();
        if (currentAction != null) currentAction.Actions();
    }
    
    public void Shoot()
    {
        Arrow newArrow = munition.arrowsPool.GetObjectFromPool();
        newArrow.ammoAmount = munition;
        newArrow.transform.position = attackPivot.position;
        newArrow.transform.forward = transform.forward;
        Rigidbody arrowRb = newArrow.GetComponent<Rigidbody>();
        arrowRb.AddForce(new Vector3(transform.forward.x, attackPivot.forward.y + 0.2f, transform.forward.z) * 950 * Time.deltaTime, ForceMode.Impulse);
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

    public override void GetDamage(float damage)
    {
        timeOnDamage = 1f;
        if (!onDamage) onDamage = true;
        TakeDamageEvent();
        life -= damage;
		_view.LifeBar(life / maxLife);
        
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
        var obs = Physics.OverlapSphere(transform.position, 2, layerObst);
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
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
        Gizmos.DrawWireSphere(transform.position, distanceToMeleeAttack);

        Vector3 rightLimit2 = Quaternion.AngleAxis(angleToMeleeAttack, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit2 * distanceToMeleeAttack));

        Vector3 leftLimit2 = Quaternion.AngleAxis(-angleToMeleeAttack, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit2 * distanceToMeleeAttack));

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, viewDistanceAttack);

        Vector3 rightLimit3 = Quaternion.AngleAxis(angleToAttack, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit3 * viewDistanceAttack));

        Vector3 leftLimit3 = Quaternion.AngleAxis(-angleToAttack, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit3 * viewDistanceAttack));

        Gizmos.DrawWireSphere(attackPivot.position, radiusAttack);
    }

 
    public override void MakeDamage()
    {
        var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();
        if (player != null)
        {          
            player.GetDamage(attackDamage, transform, false);
        }
    }

    public override void RetreatTrue()
    {
        if (!cooldwonToGoBack) onRetreat = true;
    }

    public override void OnDamageFalse()
    {
        onDamage = false;
    }

    public override void RemoveNearEntity(EnemyEntity e)
    {
        nearEntities.Remove(e);
    }
}
