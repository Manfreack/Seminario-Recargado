using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelEnemyArcher : EnemyClass {

    public bool isStuned;
    public bool isKnocked;
    public bool isBleeding;
    public bool isOcuped;
    public bool isReloading;
    public bool isScape;
    public bool isOnPatrol;
    public bool isAttackMelle;
    public bool lostTarget;
    bool startback;
    bool startSearch;
    bool increaseFollowRadio;
    public bool resting;
    public bool timeToAttack;
    bool OnAttack;

    public Action TakeDamageEvent;
    public Action MeleeAttackEvent;
    public Action RangeAttackEvent;
    public Action IdleEvent;
    public Action WalkEvent;
    public Action DeadEvent;

    public EnemyAmmo munition;
    public List<Collider> obstacles;

    public EnemyCombatManager cm;
    public Transform attackPivot;
    public LayerMask obstacleLayer;
    public LayerMask player;
    public ViewerEnemy view;
    List<Cell> transitableCells = new List<Cell>();
    public float radObst;
    public float sightSpeed;
    public float viewAngleFollow;
    public float viewDistanceFollow;
    public float viewDistanceAttackRange;
    public float viewAngleAttackRange;
    public float viewAngleAttackMelle;
    public float viewDistanceAttackMelle;
    public float speed;
    float timeToShoot;
    public float shootTime;
    float starDistaceToFollow;
    int countTimesForSearch;
    public float knockbackForce;
    float maxDileyToAttack;
    public float radiusAttack;
    public float attackDamage;
    public float radiusAvoid;
    public float avoidWeight;
    public float timeOfLook;
    public float distanceToBack;

    public StateMachine sm;  

    public override IEnumerator Bleeding(float bleedingTime)
    {
        isBleeding = true;
        yield return new WaitForSeconds(bleedingTime);
        isBleeding = false;
    }

    public override IEnumerator Knocked(float knockedTime)
    {
        isKnocked = true;
        yield return new WaitForSeconds(knockedTime);
        isKnocked = false;
    }

    public IEnumerator Resting()
    {
        resting = true;
        OnAttack = true;
        yield return new WaitForSeconds(2);
        resting = false;
        OnAttack = false;
    }

    public override IEnumerator Stuned(float stunedTimed)
    {
        isStuned = true;
        yield return new WaitForSeconds(stunedTimed);
        isStuned = false;
    }

    // Use this for initialization
    void Start () {

        startRotation = transform.forward;
        timeToShoot = shootTime;
       // startCell = GetCloseCell(transform.position);
        sm = new StateMachine();
        sm.AddState(new S_Persuit(sm, this, target.GetComponent<Model>(), speed));
        sm.AddState(new S_RangePatrol(sm, this, speed));
        sm.AddState(new S_Patrol(sm, this, speed));
        sm.AddState(new S_Idle(sm, this));
        sm.AddState(new S_LookForTarget(sm, this, speed));
        sm.AddState(new S_BackHome(sm, this, speed));
        sm.AddState(new S_Aiming(sm, this, target.transform, sightSpeed));
        sm.AddState(new S_WaitingArcher(sm,this,target));
        view = GetComponent<ViewerEnemy>();
        munition = FindObjectOfType<EnemyAmmo>();
        rb = GetComponent<Rigidbody>();
        dileyToAttack = UnityEngine.Random.Range(2f, 3f);
        sm.SetState<S_RangePatrol>();
        timeOfLook = 10;
        // ess = GetComponent<EnemyScreenSpace>();
    }
	
	// Update is called once per frame
	void Update () {

        WrapperStates();
        sm.Update();

        //var d = Vector3.Distance(startCell.transform.position, transform.position);

        //if (d > distanceToBack) isBackHome = true;

        if (target != null && !isAttack && !isAttackMelle && !isOcuped && SearchForTarget.SearchTarget(target, viewDistanceFollow, viewAngleFollow, transform, true, obstacleLayer)) isPersuit = true;
        else isPersuit = false;

        if (target != null && !isOcuped && !isAttackMelle && SearchForTarget.SearchTarget(target, viewDistanceAttackRange, viewAngleAttackRange, transform, true, obstacleLayer)) isAttack = true;
        else isAttack = false;

        if (target != null && !isOcuped && SearchForTarget.SearchTarget(target, viewDistanceAttackMelle, viewAngleAttackMelle, transform, true, obstacleLayer)) isAttackMelle = true;
        else isAttackMelle = false;

        if (isAttackMelle)
        {
            avoidVectFriends = avoidance() * avoidWeight;
            AttackMelee();
        }

        if (isBleeding && !isOcuped) life -= bleedingDamage * Time.deltaTime;


        if (!isAttack && !isPersuit && !isOcuped && !isBackHome && !isAttackMelle && !answerCall) isOnPatrol = true;
        else isOnPatrol = false;
    }

    public void FixedUpdate()
    {
        //if (isBackHome && !isAttack && !isPersuit && !isOcuped && !isAttackMelle && !answerCall) BackHome();

        if (lostTarget && !isPersuit && !isAttack && !isBackHome && !answerCall) LookForTarget();
    }

    public void AttackRange()
    {
        if (!isDead)
        {
            IdleEvent();

            startback = false;
            target.GetComponent<Model>().CombatState();
            timeToShoot -= Time.deltaTime;
            sm.SetState<S_Aiming>();
            target.GetComponent<Model>().CombatState();

            //if (timeToShoot <= 1) PrepareAttackEvent();

            if (timeToShoot <= 0)
            {
                attackPivot.LookAt(target.transform.position);

                Vector3 localPlayerPos = transform.InverseTransformPoint(target.transform.position);
                Vector3 localEnemyPos = transform.InverseTransformPoint(attackPivot.position);
                Vector3 localPlayerDir = localPlayerPos - localEnemyPos;
                Vector3 v = localPlayerDir;
                v.y = 0f;
                localPlayerDir = Quaternion.FromToRotation(v, Vector3.forward) * localPlayerDir;
                Vector3 raycastDirection = transform.TransformDirection(localPlayerDir);

                if (Physics.Raycast(attackPivot.position, raycastDirection, Mathf.Infinity, player))
                {
                    RangeAttackEvent();
                    Arrow newArrow = munition.arrowsPool.GetObjectFromPool();
                    newArrow.ammoAmount = munition;
                    newArrow.transform.position = attackPivot.position;
                    newArrow.transform.forward = transform.forward;
                    Rigidbody arrowRb = newArrow.GetComponent<Rigidbody>();
                    arrowRb.AddForce(new Vector3(transform.forward.x, attackPivot.forward.y + 0.2f, transform.forward.z) * 950 * Time.deltaTime, ForceMode.Impulse);
                    timeToShoot = shootTime;
                }
            }
        }
    }

    public override void Founded()
    {
       /* pathToTarget.Clear();
        currentIndex = 2;
        cellToPatrol = GetCloseCell(target.position);
        var myCell = GetCloseCell(transform.position);
        if (cellToPatrol != null)
        {
            pathToTarget.AddRange(myGridSearcher.Search(myCell, cellToPatrol));
            sm.SetState<S_Patrol>();
        }
        */
    }

    public void Patrol()
    {
        if (!isDead)
        {

            IdleEvent();
            sm.SetState<S_RangePatrol>();
        }
    }

    public void AttackMelee()
    {
        if (!isDead)
        {
            IdleEvent();

            answerCall = false;
            AnswerCall();
            timeToShoot = shootTime;
            if (timeToAttack) dileyToAttack -= Time.deltaTime;
            if (dileyToAttack <= 0)
            {
                MeleeAttackEvent();
                rb.AddForce(transform.forward * knockbackForce, ForceMode.Impulse);
                timeToAttack = false;
                StartCoroutine(Resting());
                dileyToAttack = UnityEngine.Random.Range(4f, 6f);
                maxDileyToAttack = dileyToAttack;
            }

            if (OnAttack)
            {
                var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();
                if (player != null)
                {
                 //   player.GetDamage(attackDamage, transform, false, false, this);
                    rb.AddForce(-transform.forward * knockbackForce * 1.5f, ForceMode.Impulse);
                    OnAttack = false;
                }
            }
        }
    }

    public void Waiting()
    {
        if (!isDead)
        {
            IdleEvent();

            startback = false;
            if (!resting && !timeToAttack)
            {
                timeToAttack = true;
            }

            sm.SetState<S_WaitingArcher>();
        }
    }

    public void Persuit()
    {
        if (!isDead)
        {
            WalkEvent();

            startback = false;
            AnswerCall();
            answerCall = false;
            lostTarget = true;
            timeOfLook = 10;
            lastTargetPosition = target.transform.position;
            sm.SetState<S_Persuit>();
        }
    }

    public void LookForTarget()
    {
        if (!isDead)
        {
            WalkEvent();

            answerCall = false;
            timeOfLook -= Time.deltaTime;
            isOnPatrol = false;
            if (timeOfLook <= 0)
            {
                lostTarget = false;
                isBackHome = true;
            }
            else
                sm.SetState<S_LookForTarget>();
        }

    }

    public void BackHome()
    {
        /*if(!isDead)
        {

            WalkEvent();

            answerCall = false;
            if (!startback)
            {
                pathToTarget.Clear();
                currentIndex = 0;
                var myCell = GetCloseCell(transform.position);
                pathToTarget.AddRange(myGridSearcher.Search(myCell, startCell));
                startback = true;
            }

            transitableCells.Clear();
            transitableCells.AddRange(GetTransitableCells());

            var distance = Vector3.Distance(transform.position, startCell.transform.position);

            if (distance <= 1)
            {
                transform.forward = startRotation;
                isBackHome = false;
                lostTarget = false;
                isOnPatrol = true;
            }
            sm.SetState<S_BackHome>();
        }
        */
    }

    public void AnswerCall()
    {

        int friendsOnBatle = 1;
        foreach (var item in myFriends)
        {
            if (item.isPersuit || item.isAttack) friendsOnBatle++;
        }

        if (friendsOnBatle <= myFriends.Count + 1)
        {
            foreach (var item in myFriends)
            {
                if (!item.isPersuit && !item.isAttack)
                {
                    item.Founded();
                    item.answerCall = true;
                }
            }
        }
    }

   /* List<Cell> GetTransitableCells()
    {
        transitableCells.Clear();
        transitableCells.AddRange(FindObjectsOfType<Cell>().Where(x => x.transitable).Where(x =>
        {
            var d = Vector3.Distance(x.transform.position, transform.position);
            if (d > 12) return false;
            else return true;

        }).Where(x => x.room == myGrid.roomNumber));

        return transitableCells;
    }

    Cell GetCloseCell(Vector3 enemy)
    {
        return FindObjectsOfType<Cell>().OrderBy(x =>
        {
            float d = Vector3.Distance(x.transform.position, enemy);
            return d;

        }).Where(x => x.transitable && x.room == myGrid.roomNumber).FirstOrDefault();


    }

    Cell GetRandomCell()
    {
        transitableCells.Clear();
        return GetTransitableCells()[UnityEngine.Random.Range(0, transitableCells.Count())];
    }
    */
    public override void GetDamage(float damage)
    {
        life -= damage;
        //ess.UpdateLifeBar(life);
        TakeDamageEvent();
       // dileyToAttack += 0.25f;
        if (life <= 0)
        {
            isDead = true;
            Dead();
        }
    }

    void OnDrawGizmos()
    {

        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position, viewDistanceAttackMelle);

        Vector3 rightLimit = Quaternion.AngleAxis(viewAngleAttackMelle, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit * viewDistanceAttackMelle));

        Vector3 leftLimit = Quaternion.AngleAxis(-viewAngleAttackMelle, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit * viewDistanceAttackMelle));

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, viewDistanceAttackRange);

        Vector3 rightLimit2 = Quaternion.AngleAxis(viewAngleAttackRange, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit2 * viewDistanceAttackRange));

        Vector3 leftLimit2 = Quaternion.AngleAxis(-viewAngleAttackRange, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit2 * viewDistanceAttackRange));

        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position, viewDistanceFollow);

        Vector3 rightLimit3 = Quaternion.AngleAxis(viewAngleFollow, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit3 * viewDistanceFollow));

        Vector3 leftLimit3 = Quaternion.AngleAxis(-viewAngleFollow, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit3 * viewDistanceFollow));

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(attackPivot.position, radiusAttack);
    }

    public void WrapperStates()
    {
        if (isDead || isKnocked || isStuned) isOcuped = true;
        else isOcuped = false;
    }

    Vector3 avoidance()
    {
        var friends = Physics.OverlapSphere(transform.position, radiusAvoid).Where(x => x.GetComponent<ModelEnemy>() && x != this).Select(x => x.GetComponent<ModelEnemy>());
        if (friends.Count() > 0)
        {
            var dir = transform.position - friends.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public void Dead()
    {
        DeadEvent();
        isDead = true;
        sm.SetState<S_Idle>();
    }

    public override IEnumerator FoundTarget(float time)
    {
        throw new System.NotImplementedException();
    }

   
}
