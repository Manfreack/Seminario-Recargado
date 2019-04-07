using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChargeTanke : Ipower
{
    Model _player;
    float _speed=15;
    Transform _mainCamera;
    Rigidbody _rb;
    float _damage = 10;
    float _force = 20;
    float _radius = 4;
    float _stunedTime = 1;
    float currentTime =0;

    public void Ipower()
    {
        currentTime += Time.deltaTime;
        if (currentTime <= 3)
        {
            var dirCamera = _mainCamera.forward;
            dirCamera.y = 0;
            _player.transform.forward = Vector3.Lerp(_player.transform.forward, dirCamera, 0.2f);
            _rb.MovePosition(_rb.position + dirCamera * _speed * Time.deltaTime);
        }
        else _player.chargeTankeState = false;
    }

    public void Ipower2()
    {
        var rbEnemy = _player.currentEnemy.GetComponent<Rigidbody>();
        var enemy = _player.currentEnemy;
        var modelEnemy = enemy.GetComponent<ModelEnemy>();
        if (!modelEnemy.isKnocked)
        {
            modelEnemy.StartCoroutine(modelEnemy.Knocked(0.5f));
            rbEnemy.AddExplosionForce(_force, _player.transform.position, _radius, 2, ForceMode.Impulse);
            //enemy.GetDamage(_damage);
            enemy.StartCoroutine(enemy.Stuned(_stunedTime));
        }
    }

    public ChargeTanke(Model player)
    {
        _player = player;
        _mainCamera = player.mainCamera;
        _rb = player.rb;
        _player.chargeTankeState = true;
    }
}
