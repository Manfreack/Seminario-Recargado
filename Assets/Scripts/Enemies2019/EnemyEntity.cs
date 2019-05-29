﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class EnemyEntity: MonoBehaviour
{
    public int aggressiveLevel;
    public float life;
    public float totalLife;
    public abstract Vector3 ObstacleAvoidance();
    public abstract Vector3 EntitiesAvoidance();
    public Vector3 avoidVectObstacles;
    public Vector3 entitiesAvoidVect;
    public bool isPersuit;
    public bool isWaitArea;
    public bool onAttack;
    public bool isAnswerCall;
    public bool isDead;
    public bool onDamage;
    public bool onRetreat;
    public bool firstSaw;
    public bool isStuned;
    public bool isKnock;
    public float timeOnDamage;
    public float timeStuned;
    public Model target;
    public int currentIndex;
    public float speed;
    public float viewDistancePersuit;
    public float angleToPersuit;
    public float viewDistanceAttack;
    public float angleToAttack;
    public abstract Node GetMyNode();
    public abstract Node GetMyTargetNode();
    public abstract Node GetRandomNode();
    public List<EnemyEntity> nearEntities = new List<EnemyEntity>();
    public List<Node> pathToTarget = new List<Node>();
    public abstract void GetDamage(float damage, string typeOfDamage);
    public abstract void MakeDamage();
    public List<Node> myNodes = new List<Node>();
    public i_EnemyActions currentAction;
    public Rigidbody rb;
    public float delayToAttack;
    public float maxDelayToAttack;
    public float knockbackForce;
    public float radiusAttack;
    public float attackDamage;
    public float timeToStopBack;
    public Vector3 positionToBack;
    public CombatArea ca;
    public abstract void RemoveNearEntity(EnemyEntity e);
    public List<CombatNode> playerNodes = new List<CombatNode>();
    public abstract CombatNode FindNearAggressiveNode();
    public abstract CombatNode FindNearNon_AggressiveNode();
    public CombatNode myCombatNode;
    public CombatNode lastCombatNode;
    public SkinnedMeshRenderer renderObject;
}
