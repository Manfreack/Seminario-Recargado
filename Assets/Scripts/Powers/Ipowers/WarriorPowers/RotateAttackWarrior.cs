using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAttackWarrior : Ipower {

    Transform _player;
    Model _model;
    float _radius=3f;
    float _force=5;
    float _damage = 10;
    float _cdTime = 5;
    Rigidbody _rb;
  

    public void Ipower()
    {
        
        Collider[] col = Physics.OverlapSphere(_player.transform.position, _radius);
        foreach (var item in col)
        {
            if (item.GetComponent<EnemyClass>())
            {
                var enemy = item.GetComponent<ModelEnemy>();

                _rb = item.GetComponent<Rigidbody>();
                _rb.AddExplosionForce(_force, _player.transform.position, _radius, 2, ForceMode.Impulse);
                enemy.StartCoroutine(enemy.Stuned(1));
                enemy.GetDamage(_damage);
            }
        }
        if (!_model.mySkills.secondRotate)
        {
            _model.StartCoroutine(_model.ActionDelay(Ipower2));
            _model.StartCoroutine(_model.InActionDelay(2.5f));
        }
        else _model.StartCoroutine(_model.InActionDelay(0.6f));
        _model.StartCoroutine(_model.PowerColdown(_cdTime,2));

    }

    public void Ipower2()
    {       
        _model.view.GolpeGiratorio();
        Collider[] col = Physics.OverlapSphere(_player.transform.position, _radius);
        foreach (var item in col) {
            if (item.GetComponent<EnemyClass>()) {
                _rb = item.GetComponent<Rigidbody>();
                _rb.AddExplosionForce(_force, _player.transform.position, _radius, 2, ForceMode.Impulse);
                item.GetComponent<EnemyClass>().GetDamage(_damage);
                if (_model.mySkills.healRotateAttack)
                {
                    _model.life += (_damage * 30) / 100;
                    if (_model.life >= _model.maxLife) _model.life = _model.maxLife;
                }
            }
        }
    }

    public RotateAttackWarrior(Transform player)
    {
        _player = player;
        _model = _player.gameObject.GetComponent<Model>();
    }
    
}
