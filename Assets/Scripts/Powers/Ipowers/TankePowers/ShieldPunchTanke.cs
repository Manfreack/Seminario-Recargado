using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldPunchTanke : Ipower
{
    Model _player;
    Rigidbody _rbEnemy;
    float _damage=10;
    float _force = 10;
    float _radius=4;
    float _stunedTime=1;

    public void Ipower()
    {
        Collider[] col = Physics.OverlapSphere(_player.transform.position, _radius);
        foreach (var item in col)
        {
            if (item.GetComponent<EnemyClass>())
            {
                _rbEnemy = item.GetComponent<Rigidbody>();
                Vector3 dir = _rbEnemy.transform.position - _player.transform.position;
                float angle = Vector3.Angle(dir, _player.transform.forward);
                if (angle < 90)
                {
                    var enemy = item.GetComponent<EnemyClass>();
                    _rbEnemy.AddExplosionForce(_force, _player.transform.position, _radius, 2, ForceMode.Impulse);
                    enemy.GetDamage(_damage);
                    enemy.StartCoroutine(enemy.Stuned(_stunedTime));
                }

            }
        }
    }

    public void Ipower2()
    {
        
    }

    public ShieldPunchTanke(Model player)
    {
        _player = player;
    }
}
