using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_Reposition : i_EnemyActions
{
    ModelE_Melee _e;
    Vector3 _posToRepos;

    public void Actions()
    {

        var dir = _posToRepos - _e.transform.position;

        var isBehind = Vector3.Dot(dir, _e.transform.forward);

        if (_e.actualRing == _e.rings[1] || _e.actualRing == _e.rings[2])
        {
           
            _e.WalkBackEvent();
            _e.transform.forward = (_e.target.transform.position - _e.transform.position).normalized;
            _e.rb.MovePosition(_e.rb.position - _e.transform.forward * _e.speed * Time.deltaTime);
        }

        if(_e.actualRing == _e.rings[0])
        {
            _e.CombatWalkEvent();
            _e.transform.forward = (_e.target.transform.position - _e.transform.position).normalized;
            _e.rb.MovePosition(_e.rb.position + _e.transform.forward * _e.speed * Time.deltaTime);
        }
    }

    public A_Reposition (ModelE_Melee e, Vector3 posToRepos)
    {
        _e = e;
        _posToRepos = posToRepos;
    }
}
