using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BiggerFireBall : IDecorator
{
    ParticleSystem _particles;

    public void IDecorator()
    {
#pragma warning disable CS0618 // El tipo o el miembro están obsoletos
        _particles.startSize += Time.deltaTime;
#pragma warning restore CS0618 // El tipo o el miembro están obsoletos
    }

    public void ConstantDecorator()
    {
        throw new System.NotImplementedException();
    }

    public BiggerFireBall(GameObject particles)
    {
        _particles = particles.GetComponent<ParticleSystem>();
    }
}
