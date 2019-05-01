using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class ModelEnemy : EnemyClass
{
    public ViewerEnemy view;
    public EnemyCombatManager cm;

    public bool isStuned;
    public bool isKnocked;
    public bool isBleeding;
    public bool isOcuped;
    public bool timeToAttack;
    public bool isOnPatrol;
    public bool resting;
    public bool lostTarget;
    public bool flankTarget;
    bool OnAttack;
    bool startback;
    bool startSearch;
    bool increaseFollowRadio;

    public Action AttackEvent;
    public Action IdleEvent;
    public Action IdleEventBack;
    public Action TakeDamageEvent;
    public Action DeadEvent;

    public List<Collider> obstacles;

    public Transform attackPivot;
    public LayerMask layerObst;
    public LayerMask layerPlayer;
    public StateMachine sm;
    List<Cell> transitableCells = new List<Cell>();
    public float attackDamage;
    public float distanceToBack;
    public float radiusAttack;
    public float viewAnglePersuit;
    public float viewDistancePersuit;
    public float distanceToTraget;
    public float viewDistanceAttack;
    public float viewAngleAttack;
    public float radiusAvoid;
    public float avoidWeight;
    public float speed;
    public float knockbackForce;
    float maxDileyToAttack;
    public float timeToChangePatrol;
    public float timeOfLook;

    public IEnumerator Resting()
    {
        resting = true;
        OnAttack = true;
        yield return new WaitForSeconds(2);
        resting = false;
        OnAttack = false;
    }

    public IEnumerator PatrolCorrutine()
    {
        yield return new WaitForSeconds(1);
    }

    public override IEnumerator Stuned(float stunedTime)
    {
        yield return new WaitForSeconds(1);
    }

    public override IEnumerator Knocked(float knockedTime)
    {
        yield return new WaitForSeconds(1);
    }

    public override IEnumerator Bleeding(float bleedingTime)
    {
        yield return new WaitForSeconds(1);
    }

    public IEnumerator AttackCorrutine()
    {
        yield return new WaitForSeconds(1);
    }

    private void Awake()
    {
        pathToTarget = new List<Cell>();
    }

    void Start()
    {
        startRotation = transform.forward;
        //transitableCells.AddRange(GetTransitableCells());

        //startCell = GetCloseCell(transform.position);
        sm = new StateMachine();
        sm.AddState(new S_Persuit(sm, this, target.GetComponent<Model>(), speed));
        sm.AddState(new S_LookForTarget(sm, this, speed));
        sm.AddState(new S_Idle(sm, this));
        sm.AddState(new S_Waiting(sm, this, this, target, speed));
        sm.AddState(new S_Patrol(sm, this, speed));
        sm.AddState(new S_BackHome(sm, this, speed));
        sm.SetState<S_Patrol>();
        rb = GetComponent<Rigidbody>();
        cm = FindObjectOfType<EnemyCombatManager>();
        dileyToAttack = UnityEngine.Random.Range(2f, 3f);
        //cellToPatrol = GetRandomCell();
        timeToChangePatrol = 0;
        timeOfLook = 10;
        

    }

    void Update()
    {
        sm.Update();
       
        avoidVectObstacles = AvoidObstacles();

        //var d = Vector3.Distance(startCell.transform.position, transform.position);

        //if (d > distanceToBack) isBackHome = true;

        if (!isAttack && !isOcuped && !isBackHome && SearchForTarget.SearchTarget(target, viewDistancePersuit, viewAnglePersuit, transform, true, layerObst)) isPersuit = true;
        else isPersuit = false;

        if (target != null && !isOcuped && !isBackHome && SearchForTarget.SearchTarget(target, viewDistanceAttack, viewAngleAttack, transform, true, layerObst)) isAttack = true;
        else isAttack = false;


        if (!isAttack && !isPersuit && !isOcuped && !isBackHome && !lostTarget) isOnPatrol = true;
        else isOnPatrol = false;


    }


    private void FixedUpdate()
    {

        if (lostTarget && !isPersuit && !isAttack && !isBackHome && !answerCall) LookForTarget();

        if (isAttack)
        {
            avoidVectFriends = avoidance() * avoidWeight;
            Attack();
        }

        //if (isBackHome && !isAttack && !isPersuit && !isOcuped && !answerCall) BackHome();
     
        
    }

    public void Persuit()
    {
        if (!isDead)
        {
            IdleEventBack();
            startback = false;
            AnswerCall();
            answerCall = false;
            lostTarget = true;
            timeOfLook = 10;
            timeToChangePatrol = 0;
            lastTargetPosition = target.transform.position;
            sm.SetState<S_Persuit>();
        }
    }

    public override void Founded()
    {
       /*/ pathToTarget.Clear();
        currentIndex = 2;
        cellToPatrol = GetCloseCell(target.position);   
        myCell = GetCloseCell(transform.position);        
        if(cellToPatrol!=null)  pathToTarget.AddRange(myGridSearcher.Search(myCell, cellToPatrol));*/
    }

    public void LookForTarget()
    {
        if (!isDead)
        {
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
        /*if (!isDead)
        {
            lostTarget = false;
            answerCall = false;
            if (!startback)
            {
                pathToTarget.Clear();
                currentIndex = 0;
                myCell = GetCloseCell(transform.position);
                while(cellToPatrol==null)
                {
                    myCell = GetCloseCell(transform.position);
                }
                pathToTarget.AddRange(myGridSearcher.Search(myCell, startCell));
                startback = true;
            }

            transitableCells.Clear();
            transitableCells.AddRange(GetTransitableCells());

            var distance = Vector3.Distance(transform.position, startCell.transform.position);

            if (distance <= 2)
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

    public void Patrol()
    {

       /* if (!isDead)
        {
            if (currentIndex < pathToTarget.Count) IdleEventBack();
            if (currentIndex >= pathToTarget.Count) IdleEvent();

            if (!lostTarget)
            {

                transitableCells.Clear();
                transitableCells.AddRange(GetTransitableCells());

                timeToChangePatrol -= Time.deltaTime;
                if (timeToChangePatrol <= 0)
                {
                    pathToTarget.Clear();
                    currentIndex = 0;
                    myCell = GetCloseCell(transform.position);


                    cellToPatrol = GetRandomCell();

                    if (cellToPatrol == null) cellToPatrol = myCell;

                    timeToChangePatrol = UnityEngine.Random.Range(6, 10);
                    pathToTarget.AddRange(myGridSearcher.Search(myCell, cellToPatrol));
                }

                sm.SetState<S_Patrol>();
            }
        }
        */
    }

    public void WaitTurn()
    {
        if (!isDead)
        {
            startback = false;
            answerCall = false;
            target.GetComponent<Model>().CombatState();

            bool aux = false;          
            
            var friendsMelee = FindObjectsOfType<ModelEnemy>();

            foreach (var item in friendsMelee) if (item.flankTarget) aux = true;

            if (!resting && cm.times > 0 && !timeToAttack && !aux)
            {
                var speed = UnityEngine.Random.Range(0, 1);
                sm.AddState(new S_Waiting(sm, this, this, target, speed));
                timeToAttack = true;
                cm.times--;


                if (cm.times <= 0 && !aux)
                {
                    flankTarget = true;
                }
            }

            sm.SetState<S_Waiting>();
        }
    }

    public void Attack()
    {
        if (!isDead)
        {
            answerCall = false;
            AnswerCall();

            if (flankTarget) IdleEventBack();
            else IdleEvent();

            if (timeToAttack) dileyToAttack -= Time.deltaTime;
            if (dileyToAttack <= 0)
            {
                rb.AddForce(transform.forward * knockbackForce, ForceMode.Impulse);
                timeToAttack = false;
                StartCoroutine(Resting());
                cm.times++;
                dileyToAttack = UnityEngine.Random.Range(4f, 6f);
                maxDileyToAttack = dileyToAttack;
                if (flankTarget)
                {
                    flankTarget = false;
                }
                AttackEvent();
            }

            if (OnAttack)
            {
                var player = Physics.OverlapSphere(attackPivot.position, radiusAttack).Where(x => x.GetComponent<Model>()).Select(x => x.GetComponent<Model>()).FirstOrDefault();
                if (player != null)
                {
                    player.GetDamage(attackDamage, transform, false);
                    rb.AddForce(-transform.forward * knockbackForce * 1.25f, ForceMode.Impulse);
                    OnAttack = false;
                }
            }
        }
        
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

        }).Where(x=>  x.room == myGrid.roomNumber));

        return transitableCells;
    }

    Cell GetCloseCell(Vector3 enemy)
    {
        return FindObjectsOfType<Cell>().OrderBy(x =>
        {
            float d = Vector3.Distance(x.transform.position, enemy);
            return d;

        }).Where(x=> x.transitable && x.room == myGrid.roomNumber).FirstOrDefault();      
      
        
    }

    Cell GetRandomCell()
    {
        transitableCells.Clear();
        return GetTransitableCells()[UnityEngine.Random.Range(0, transitableCells.Count())];
    }
    */

    void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position, viewDistancePersuit);

        Vector3 rightLimit = Quaternion.AngleAxis(viewAnglePersuit, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (rightLimit * viewDistancePersuit));

        Vector3 leftLimit = Quaternion.AngleAxis(-viewAnglePersuit, transform.up) * transform.forward;
        Gizmos.DrawLine(transform.position, transform.position + (leftLimit * viewDistancePersuit));

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, viewDistanceAttack);

        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(attackPivot.position, radiusAttack);

    }

    public override void GetDamage(float damage)
    {
       // dileyToAttack += 0.25f;
        TakeDamageEvent();
        if (dileyToAttack > maxDileyToAttack)
        {
            dileyToAttack = maxDileyToAttack;
        }
        life -= damage;
        if (life <= 0) Dead();

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

    Vector3 AvoidObstacles()
    {
        var obs = Physics.OverlapSphere(transform.position, 2,layerObst);
        if (obs.Count() > 0)
        {
            var dir = transform.position - obs.First().transform.position;
            return dir.normalized;
        }
        else return Vector3.zero;
    }

    public void Dead()
    {
        DeadEvent();       
        isDead = true;
        if(flankTarget)
        {
            flankTarget = false;
            
        }
        if (cm.times < 2) cm.times++;
        sm.SetState<S_Idle>();
    }

    public override IEnumerator FoundTarget(float time)
    {
        throw new NotImplementedException();
    }

    public void OnTriggerEnter(Collider c)
    {
        if(c.gameObject.layer == LayerMask.NameToLayer("GoBack"))
        isBackHome = true;     
    }

}
