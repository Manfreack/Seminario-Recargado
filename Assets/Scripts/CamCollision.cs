//(Created CSharp Version) 10/2010: Daniel P. Rossi (DR9885) 

using UnityEngine;
using System.Collections;

public class CamCollision : MonoBehaviour
{
    Model model;
    public Transform target;
    public Transform pivot;
    float distFromTarget;
    public LayerMask collisionMask;

    [Header("Distances")]
    public float idleDistance = 2.83f;
    public float combatDistance = 5.14f;
    public float evenCloserDistanceToPlayer = 1;

    [Header("Speeds")]
    public float moveSpeed = 5;
    public float returnSpeed = 9;
    public float wallPush = 0.7f;

    void Awake()
    {
        model = FindObjectOfType<Model>();
    }

    void LateUpdate()
    {
        if (model.isInCombat)
            distFromTarget = combatDistance;
        else
            distFromTarget = idleDistance;

        CollisionCheck(target.position - transform.forward * distFromTarget);
    }

    private void CollisionCheck(Vector3 retPoint)
    {
        RaycastHit hit;

        if (Physics.Linecast(target.position, retPoint, out hit, collisionMask))
        {
            if (Vector3.Distance(Vector3.Lerp(transform.position, hit.point, moveSpeed * Time.deltaTime), target.position) > evenCloserDistanceToPlayer)
                transform.position = Vector3.Lerp(transform.position, hit.point, moveSpeed * Time.deltaTime * 1.2f);
        }
        else
        {
            Vector3 fixedRetPoint = retPoint;
            fixedRetPoint.y = pivot.position.y;
            transform.position = Vector3.Lerp(transform.position, fixedRetPoint, returnSpeed * Time.deltaTime);
        }
    }
}