using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public abstract class EnemyEntity: MonoBehaviour
{
    public bool onCombat;
    public bool cantRespawn;
    public GameObject healthBar;
    public EnemyPointer myPointer;
    public NavMeshAgent navMeshAgent;
    public int EnemyID_Area;
    public bool firstEnemyToSee;
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
    public abstract void GetDamage(float damage, string typeOfDamage, int damageAnimationIndex);
    public abstract void MakeDamage();
    public abstract void ChangeChatAnimation();
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
    public abstract void Respawn();
    public CombatNode myCombatNode;
    public CombatNode lastCombatNode;
    public SkinnedMeshRenderer renderObject;

    [Header("Enemy PatrolOptions:")]

    public float timeToPatrol;
    public float timeToChat;
    public float chatCurrentTime;
    public bool enemyPointer;
    public bool chating;
    public bool patroling;
    public bool chat1;
    public bool chat2;
    public bool chat3;

    public abstract void SetChatAnimation();
 
}
