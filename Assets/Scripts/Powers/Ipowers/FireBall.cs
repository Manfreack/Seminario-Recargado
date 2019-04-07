using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireBall : Ipower
{
    Powers _power;
    Model _model;
    float _speed = 10;
    float _damage = 10;

    public void Ipower()
    {
        _power.transform.position += _model.transform.forward * _speed * Time.deltaTime;
    }

    public void Ipower2()
    {
        throw new System.NotImplementedException();
    }

    public FireBall(Powers power , Model model, float extraDamage)
    {
        _power = power;
        _model = model;
        _damage += extraDamage;
        _power.damage += _damage;
        _power.myCaller = model.transform;
        Debug.Log(_damage);
    }

}
