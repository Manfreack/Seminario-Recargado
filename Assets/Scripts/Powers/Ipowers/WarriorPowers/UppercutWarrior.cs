using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UppercutWarrior : Ipower {

    Model _player;
    Rigidbody _rb;
    Rigidbody _rbEnemy;
    float _force = 8;
    float _damage = 10;
    float _radius = 2.5f;
    float _force2 = 9;
    float _cdTime = 5;
    float time;

    public void Ipower()
    {
       
            _rb.velocity = Vector3.zero;
            _rb.AddForce(new Vector3(0, 1, 0) * _force2, ForceMode.Impulse);
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
                        _rbEnemy.AddForce(new Vector3(0, 1, 0) * _force, ForceMode.Impulse);
                        item.GetComponent<EnemyClass>().GetDamage(_damage);
                    }

                }
            }
            _player.StartCoroutine(_player.PowerColdown(_cdTime, 3));
            _player.StartCoroutine(_player.InActionDelay(1.5f));
        
    }

    public void Ipower2()
    {
        
    }

    public UppercutWarrior(Model player)
    {
        _player = player;
        _rb = _player.GetComponent<Rigidbody>();
    }
}
