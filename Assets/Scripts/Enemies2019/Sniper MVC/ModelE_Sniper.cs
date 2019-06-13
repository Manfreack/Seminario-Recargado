using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;
using UnityEngine.AI;

public class ModelE_Sniper : EnemyEntity
{
    public enum EnemyInputs { PATROL, PERSUIT, ATTACK, MELEE_ATTACK, FOLLOW, DIE, ANSWER, RETREAT, STUNED }
    private EventFSM<EnemyInputs> _myFsm;
    public LayerMask layerObst;
    public LayerMask layerEntites;
    public LayerMask layerPlayer;
    public LayerMask layerObstAndBarrels;
    ViewerE_Sniper _view;
    public Transform attackPivot;
    public float timeToShoot;
    public EnemyAmmo munition;
    public float distanceToMeleeAttack;
    public float angleToMeleeAttack;
    public bool onMeleeAttack;
    public float timeToMeleeAttack;
    public bool cooldwonToGoBack;
    public float timeToRetreat;
    public float maxTimeToRetreat;
    public float maxTimeDelayMeleeAttack;
    public float minTimeDelayMeleeAttack;
    public Transform scapeNodesParent;

    public Action TakeDamageEvent;
    public Action DeadEvent;
    public Action AttackEvent;
    public Action AttackMeleeEvent;
    public Action MoveEvent;
    public Action IdleEvent;
    public Action StunedEvent;
	
	public float maxLife;

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
        navMeshAgent = GetComponent<NavMeshAgent>();
        playerNodes.AddRange(FindObjectsOfType<CombatNode>());
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Sniper>();
        munition = FindObjectOfType<EnemyAmmo>();
        timeToShoot = UnityEngine.Random.Range(3, 5);
        timeToMeleeAttack = UnityEngine.Random.Range(minTimeDelayMeleeAttack, maxTimeDelayMeleeAttack);
        timeToStopBack = UnityEngine.Random.Range(3, 4);
		maxLife = life;
        var myEntites = FindObjectsOfType<EnemyEntity>().Where(x => x != this && x.EnemyID_Area == EnemyID_Area);
        nearEntities.Clear();
        nearEntities.AddRange(myEntites);

        var patrol = new FSM_State<EnemyInputs>("PATROL");
        var persuit = new FSM_State<EnemyInputs>("PERSUIT");
        var attack = new FSM_State<EnemyInputs>("ATTACK");
        var melee_attack = new FSM_State<EnemyInputs>("MELEE_ATTACK");
        var die = new FSM_State<EnemyInputs>("DIE");
        var follow = new FSM_State<EnemyInputs>("FOLLOW");
        var answerCall = new FSM_State<EnemyInputs>("ANSWER");
        var retreat = new FSM_State<EnemyInputs>("RETREAT");
        var stuned = new FSM_State<EnemyInputs>("STUNED");

        TakeDamageEvent += _view.TakeDamageAnim;
        DeadEvent += _view.DeadAnim;
        AttackEvent += _view.AttackRangeAnim;
        AttackMeleeEvent += _view.AttackMeleeAnim;
        IdleEvent += _view.IdleAnim;
        MoveEvent += _view.MoveFlyAnim;
        StunedEvent += _view.StunedAnim;

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
          .SetTransition(EnemyInputs.STUNED, stuned)
          .SetTransition(EnemyInputs.DIE, die)
          .Done();

        StateConfigurer.Create(persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.MELEE_ATTACK, melee_attack)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.STUNED, stuned)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(attack)
         .SetTransition(EnemyInputs.MELEE_ATTACK, melee_attack)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.RETREAT, retreat)
         .SetTransition(EnemyInputs.STUNED, stuned)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(melee_attack)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.RETREAT, retreat)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(stuned)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.FOLLOW, follow)
         .SetTransition(EnemyInputs.RETREAT, retreat)
         .SetTransition(EnemyInputs.DIE, die)
         .Done();

        StateConfigurer.Create(follow)
         .SetTransition(EnemyInputs.PERSUIT, persuit)
         .SetTransition(EnemyInputs.ATTACK, attack)
         .SetTransition(EnemyInputs.STUNED, stuned)
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

            if (!isDead && isPersuit && !isWaitArea) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isAnswerCall) SendInputToFSM(EnemyInputs.ANSWER);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);

          //  if (!isDead && onMeleeAttack && onDamage) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && !isWaitArea && !isPersuit && !onMeleeAttack && onDamage) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        patrol.OnExit += x =>
        {
            angleToPersuit = 180;
        };

        answerCall.OnEnter += x =>
        {

        };

        answerCall.OnFixedUpdate += () =>
        {

            angleToPersuit = 180;
            currentAction = new A_FollowTarget(this);
            if (!onDamage) MoveEvent();
            if (!isDead && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);
        };

        answerCall.OnExit += x =>
        {
            if (navMeshAgent)
            {
                if (navMeshAgent.enabled) navMeshAgent.enabled = false;
            }
        };

        persuit.OnEnter += x =>
        {
            MoveEvent();
            if (navMeshAgent)
            {
                if (navMeshAgent.enabled) navMeshAgent.enabled = false;
            }
        };

        persuit.OnFixedUpdate += () =>
        {
            navMeshAgent.enabled = false;

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!onDamage) MoveEvent();

            currentAction = new A_Persuit(this);

          //  if (!isDead && onMeleeAttack) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && !isWaitArea && !isPersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        attack.OnEnter += x =>
        {
            IdleEvent();

            if (navMeshAgent)
            {
                if (navMeshAgent.enabled) navMeshAgent.enabled = false;
            }
        };

        attack.OnUpdate += () =>
        {

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            timeToShoot -= Time.deltaTime;

            currentAction = new A_SniperAttack(this);

            timeToRetreat -= Time.deltaTime;

            var d = Vector3.Distance(transform.position, target.transform.position);

            if (timeToRetreat <= 0) onRetreat = true;

            // if (!isDead && onMeleeAttack) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && !isWaitArea && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isWaitArea && !isPersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (!isDead && onRetreat && timeToRetreat < 0 && d<=1.5) SendInputToFSM(EnemyInputs.RETREAT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

        };

        stuned.OnEnter += x =>
        {
            if (navMeshAgent)
            {
                if (navMeshAgent.enabled) navMeshAgent.enabled = false;
            }
            timeStuned = 3;
            StunedEvent();
        };

        stuned.OnUpdate += () =>
        {
            timeStuned -= Time.deltaTime;

            currentAction = new A_Idle();

            if (isDead) SendInputToFSM(EnemyInputs.DIE);

            if (!isDead && !isWaitArea && isPersuit && timeStuned <=0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isWaitArea && !isPersuit && timeStuned <= 0) SendInputToFSM(EnemyInputs.FOLLOW);

            if (!isDead && onRetreat && timeToRetreat < 0 && timeStuned <= 0) SendInputToFSM(EnemyInputs.RETREAT);

            if (!isDead && isWaitArea && timeStuned <=0 ) SendInputToFSM(EnemyInputs.ATTACK);

        };

        stuned.OnExit += x =>
        {
            isStuned = false;
            _view.StunedAnimFalse();
        };

        melee_attack.OnUpdate += () =>
        {

            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            timeToMeleeAttack -= Time.deltaTime;

            timeToRetreat -= Time.deltaTime;

           
            currentAction = new A_SniperMeleeAttack(this);

            if (!isDead && isWaitArea && !onRetreat) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && !isWaitArea && isPersuit && !onRetreat && timeToRetreat < 0) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && !isWaitArea && !isPersuit && !onRetreat && timeToStopBack<=0 && timeToRetreat < 0) SendInputToFSM(EnemyInputs.FOLLOW);

           

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        retreat.OnEnter += x =>
        {
            _view.anim.SetBool("Retreat", true);

            MoveEvent();

            if (navMeshAgent)
            {
                if (navMeshAgent.enabled) navMeshAgent.enabled = false;
            }

            timeToStopBack = UnityEngine.Random.Range(5, 6);

            positionToBack = FindNearScapeNode();

            timeToRetreat = maxTimeToRetreat;
        };

        retreat.OnUpdate += () =>
        {


            timeToStopBack -= Time.deltaTime;

            currentAction = new A_GoBackFromAttack(this);

            if (!isDead && isPersuit && !isWaitArea && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea && !onRetreat) SendInputToFSM(EnemyInputs.ATTACK);

            // if (!isDead && onMeleeAttack && !onRetreat) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (!isDead && !isWaitArea && !isPersuit && !onMeleeAttack && !onRetreat) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        retreat.OnExit += x =>
        {
            _view.anim.SetBool("Retreat", false);
        };

        follow.OnEnter += x =>
        {
            MoveEvent();
        };


        follow.OnUpdate += () =>
        {

            currentAction = new A_FollowTarget(this);

            if (!onDamage) MoveEvent();

            if (!isDead && !isWaitArea && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isStuned) SendInputToFSM(EnemyInputs.STUNED);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);
        };

        follow.OnExit += x =>
        {
            if (navMeshAgent)
            {
                if (navMeshAgent.enabled) navMeshAgent.enabled = false;
            }
        };

        die.OnEnter += x =>
        {
            navMeshAgent.enabled = false;
            DeadEvent();
            currentAction = null;

            if (nearEntities.Count > 0)
            {
                foreach (var item in nearEntities)
                {
                    RemoveNearEntity(item);
                }
            }

            ca.myEntities--;
        };


        _myFsm = new EventFSM<EnemyInputs>(patrol);
    }


    private void SendInputToFSM(EnemyInputs inp)
    {
        _myFsm.SendInput(inp);
    }

    public void Start()
    {
        if (!firstEnemyToSee) gameObject.SetActive(false);
    }

    private void Update()
    {
        _myFsm.Update();

        //avoidVectObstacles = ObstacleAvoidance();
        entitiesAvoidVect = EntitiesAvoidance();

        if (target != null && SearchForTarget.SearchTarget(target.transform, viewDistancePersuit, angleToPersuit, transform, true, layerObst)) isPersuit = true;
        else isPersuit = false;

        if (target != null &&  SearchForTarget.SearchTarget(target.transform, viewDistanceAttack, angleToAttack, transform, true, layerObst)) isWaitArea = true;
        else isWaitArea = false;

        if (target != null && SearchForTarget.SearchTarget(target.transform, distanceToMeleeAttack, angleToMeleeAttack, transform, true, layerObst)) onMeleeAttack = true;
        else onMeleeAttack = false;

    }

    private void FixedUpdate()
    {
        _myFsm.FixedUpdate();
        if (currentAction != null) currentAction.Actions();
    }
    
    public void Shoot()
    {
       
        Arrow newArrow = munition.arrowsPool.GetObjectFromPool();
        newArrow.gameObject.SetActive(false);
        newArrow.ammoAmount = munition;
        newArrow.transform.position = attackPivot.position;
        var dir = (target.transform.position - newArrow.transform.position).normalized;
        dir.y = 0;
        newArrow.gameObject.SetActive(true);
        newArrow.transform.forward = dir;
    }

    public override Vector3 EntitiesAvoidance()
    {
        var obs = Physics.OverlapSphere(transform.position, 1, layerEntites);
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public override void GetDamage(float damage, string typeOfDamage)
    {
        timeOnDamage = 1f;
        if (!onDamage)
        {
            onDamage = true;
            StartCoroutine(OnDamageCorrutine());
        }

        if (typeOfDamage == "Normal")
        {
            timeStuned = 0;
            TakeDamageEvent();
            life -= damage;
            _view.LifeBar(life / maxLife);
            _view.CreatePopText(damage);
        }

        if (typeOfDamage == "Stune")
        {
            isStuned = true;
            life -= damage;
            _view.LifeBar(life / maxLife);
            _view.CreatePopText(damage);
        }

        if (life <= 0)
        {
            isDead = true;
            SendInputToFSM(EnemyInputs.DIE);
        }
    }

    public Vector3 FindNearScapeNode()
    {
        var nodes = scapeNodesParent.GetComponentsInChildren<Transform>().Where(x => x != scapeNodesParent).Where(x=>
        {
            var d = Vector3.Distance(x.transform.position, transform.position);
            if (d < 1) return false;
            else return true;

        }).ToList();

        var r = UnityEngine.Random.Range(0, nodes.Count - 1);

        return nodes[r].transform.position;
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
        var obs = Physics.OverlapSphere(transform.position, 2, layerObstAndBarrels);
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
            player.GetDamage(attackDamage, transform, false, false);
        }
    }

    public void OnDamageFalse()
    {
        onDamage = false;
    }

    public override void RemoveNearEntity(EnemyEntity e)
    {
        e.nearEntities.Remove(this);
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

        if (myCombatNode != lastCombatNode)
        {
            lastCombatNode.myOwner = null;
            lastCombatNode = myCombatNode;
        }

        var NearNodes = Physics.OverlapSphere(myCombatNode.transform.position, 1).Where(y => y.GetComponent<CombatNode>()).Select(y => y.GetComponent<CombatNode>()).Where(y => y.myOwner == null);

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

        var NearNodes = Physics.OverlapSphere(myCombatNode.transform.position, 1).Where(y => y.GetComponent<CombatNode>()).Select(y => y.GetComponent<CombatNode>()).Where(y => y.myOwner == null);

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
}
