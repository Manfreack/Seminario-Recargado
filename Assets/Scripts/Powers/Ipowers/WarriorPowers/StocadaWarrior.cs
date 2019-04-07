using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StocadaWarrior : Ipower {

    float _currentTime;
    float _totalTime=0.25f;
    float _currentTime2;
    float _totalTime2 = 0.5f;
    float _speed=40;
    Model _player;
    Rigidbody _rb;
    PowerManager _manager;
    Vector3 dir;
    List<Collider> colliderEnemies = new List<Collider>();
    float _damage = 10;
    float _radius = 3;
    float _cdTime = 5;
    IDecorator _decorator;
    bool _decoratorActivator;
    bool aux;
    bool corrutineActivate;
    int amountTimes;
    int counterEnemies;

    public void Ipower()
    {

        _currentTime2 += Time.deltaTime;
        if (_currentTime2 > _totalTime2)
        {
            _currentTime += Time.deltaTime;
            if (_currentTime < _totalTime)
            {
                _player.rb.MovePosition(_player.transform.position + dir * _speed * Time.deltaTime);
                if (!corrutineActivate)
                {
                    _player.StartCoroutine(_player.PowerColdown(_cdTime, 1));
                    corrutineActivate = true;
                    _player.view.NoBackEstocada();
                }
            }
            else
            {
              _player.stocadaState = false;
              _player.onPowerState = false;
              _player.view.BackEstocada();
              _player.powerManager.constancepower = false;
            }
        }
    }

    public void Ipower2()
    {
        _currentTime = _totalTime;

        Collider[] col = Physics.OverlapSphere(_player.transform.position, _radius);

        Collider[] col2 = Physics.OverlapSphere(_player.transform.position, 15);

        if (!aux)
        {
            for (int i = 1; i < col2.Length; i++)
            {             
                if (col2[i].GetComponent<EnemyClass>() && col2[i] != _player.enemy) colliderEnemies.Add(col2[i]);
            }

            amountTimes = colliderEnemies.Count;
            if (amountTimes > 3) amountTimes = colliderEnemies.Count - (colliderEnemies.Count - 3);
            _manager.amountOfTimes = amountTimes;
            _manager.enemies = colliderEnemies;
        }

        foreach (var item in col)
        {
            if (item.GetComponent<EnemyClass>())
            {
                var enemy = item.GetComponent<EnemyClass>();
                enemy.bleedingDamage = 15;
                enemy.StartCoroutine(enemy.Bleeding(1));
                enemy.StartCoroutine(enemy.Knocked(1));
                _rb = item.GetComponent<Rigidbody>();
                _rb.AddExplosionForce(2, _player.transform.position, 5, 2, ForceMode.Impulse);
                enemy.GetDamage(_damage);
            }
        }

        if (!_player.mySkills.MultipleStocada && counterEnemies < amountTimes)
        {
            dir = colliderEnemies[counterEnemies].transform.position - _player.transform.position;
            dir.y = 0;
            _player.transform.forward = dir;
            aux = true;
            _player.stocadaState = true;                   
            _currentTime = 0;
            _speed = 5;
            counterEnemies++;
        }
    }

    public StocadaWarrior(Model player, PowerManager manager)
    {
        _player = player;
        _manager = manager;
        _player.stocadaState = true;
        dir = _player.transform.forward;
        _player.Estocada();
    }
}
