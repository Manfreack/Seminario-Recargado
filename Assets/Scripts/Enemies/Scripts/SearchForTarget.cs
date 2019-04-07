using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SearchForTarget : MonoBehaviour {

  

   public static bool SearchTarget(Transform target, float viewDistance, float viewAngle, Transform follower, bool detector , LayerMask layer)
    {
        var _viewAngle = viewAngle;
        var _viewDistance = viewDistance;
        var _enemy = follower;

        if (target == null) return false;

        var _dirToTarget = (target.position - _enemy.position).normalized;

        var _angleToTarget = Vector3.Angle(_enemy.forward, _dirToTarget);

        var _distanceToTarget = Vector3.Distance(_enemy.position, target.position);

        bool obstaclesBetween = false;

        RaycastHit hit;

        if (detector)
        {         
            if (Physics.Raycast(_enemy.position, _dirToTarget , out hit, _distanceToTarget, layer))
            {
                if (hit.transform.name == target.name)
                {
                    Debug.DrawLine(_enemy.position, hit.point, Color.yellow);
                }
                else
                {
                    Debug.DrawLine(_enemy.position, hit.point, Color.red);
                    obstaclesBetween = true;
                }
                
                
            }           
        }

        if (_angleToTarget <= _viewAngle && _distanceToTarget <= _viewDistance && !obstaclesBetween)
        {
              return true;
        }
        else
        {
            return false;
        }
    }
}

