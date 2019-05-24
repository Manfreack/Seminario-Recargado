﻿using System.Collections;
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
        playerNodes.AddRange(FindObjectsOfType<CombatNode>());
        rb = gameObject.GetComponent<Rigidbody>();
        _view = GetComponent<ViewerE_Sniper>();
        munition = FindObjectOfType<EnemyAmmo>();
        timeToShoot = UnityEngine.Random.Range(3, 5);
        timeToMeleeAttack = UnityEngine.Random.Range(minTimeDelayMeleeAttack, maxTimeDelayMeleeAttack);
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
         .SetTransition(EnemyInputs.RETREAT, retreat)
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

        answerCall.OnFixedUpdate += () =>
        {

            angleToPersuit = 180;
            currentAction = new A_FollowTarget(this);
            if (!onDamage) MoveEvent();
            if (!isDead && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);
        };

        persuit.OnFixedUpdate += () =>
        {


            isAnswerCall = false;

            firstSaw = true;

            foreach (var item in nearEntities) if (!item.isAnswerCall && !item.firstSaw) item.isAnswerCall = true;

            if (!onDamage) MoveEvent();

            currentAction = new A_Persuit(this);

          //  if (!isDead && onMeleeAttack) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);

            if (!isDead && !isWaitArea && !isPersuit) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
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

            if (!isDead && onRetreat && timeToRetreat < 0 && d<=1.5) SendInputToFSM(EnemyInputs.RETREAT);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
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
            
            timeToStopBack = UnityEngine.Random.Range(5, 6);

            positionToBack = FindNearScapeNode();

            timeToRetreat = maxTimeToRetreat;
        };

        retreat.OnUpdate += () =>
        {
            Debug.Log("asdasd");

            timeToStopBack -= Time.deltaTime;

            currentAction = new A_GoBackFromAttack(this);

            if (!isDead && isPersuit && !isWaitArea && !onRetreat) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea && !onRetreat) SendInputToFSM(EnemyInputs.ATTACK);

           // if (!isDead && onMeleeAttack && !onRetreat) SendInputToFSM(EnemyInputs.MELEE_ATTACK);

            if (!isDead && !isWaitArea && !isPersuit && !onMeleeAttack && !onRetreat) SendInputToFSM(EnemyInputs.FOLLOW);

            if (isDead) SendInputToFSM(EnemyInputs.DIE);
        };

        follow.OnEnter += x =>
        {           
            Node start = GetMyNode();
            Node end = GetMyTargetNode();

            var originalPathToTarget = MyBFS.GetPath(start, end, myNodes);
            originalPathToTarget.Remove(start);
            pathToTarget.AddRange(originalPathToTarget);
            currentIndex = pathToTarget.Count;
        };


        follow.OnUpdate += () =>
        {

            currentAction = new A_FollowTarget(this);

            if (!onDamage) MoveEvent();

            if (!isDead && !isWaitArea && isPersuit) SendInputToFSM(EnemyInputs.PERSUIT);

            if (!isDead && isWaitArea) SendInputToFSM(EnemyInputs.ATTACK);
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

    public override void GetDamage(float damage)
    {
        timeOnDamage = 1f;
        if (!onDamage)
        {
            onDamage = true;
            StartCoroutine(OnDamageCorrutine());
        }
        TakeDamageEvent();
        life -= damage;
		_view.LifeBar(life / maxLife);
        _view.CreatePopText(damage);

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
