using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Slame : Ipower
{
    Rigidbody _rb;
    Vector3 _actualPosition;
    float _force=5;
    float _damage=10;
    float _radius=2;

    public Slame(Vector3 actualPosition, float damage, float radius, Rigidbody rb)
    {
        _actualPosition = actualPosition;
        _damage += damage;
        _radius += radius;
		_rb = rb;
    }

    public void Ipower()
    {
      
        Collider[] col = Physics.OverlapSphere(_actualPosition, _radius);
        foreach (var item in col)
        {
            if (item.GetComponent<EnemyClass>())
            {
                _rb = item.GetComponent<Rigidbody>();
				_rb.AddExplosionForce(_force, _actualPosition, _radius, 2, ForceMode.Impulse);
				//item.GetComponent<EnemyClass>().GetDamage(_damage);
                
            }
        }
    }

    public void Ipower2()
    {
        throw new System.NotImplementedException();
    }
}
