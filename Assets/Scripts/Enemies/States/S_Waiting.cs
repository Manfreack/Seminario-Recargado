using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Waiting : EnemyState
{
    Transform _player;
    Model _modelPlayer;
    ModelEnemy _model;
    Vector3 _dirToTarget;
    float _flankSpeed;

    public S_Waiting(StateMachine sm, EnemyClass e, ModelEnemy model, Transform player, float rotateSpeed) : base(sm, e)
    {
        _modelPlayer = player.GetComponent<Model>();
        _model = model;
        _player = player;
        _flankSpeed = rotateSpeed;
    }

    public override void Awake()
    {

        base.Awake();
    }

    public override void Execute()
    {
        base.Execute();

        _modelPlayer.CombatState();

        if (_model.avoidVectFriends != Vector3.zero && !_model.flankTarget)
        {
            _model.transform.position += _model.avoidVectFriends * _model.speed * Time.deltaTime;
        }

        if (_model.flankTarget)
        {
            var rotateSpeed = 0;

            if (_flankSpeed < 1) rotateSpeed = 25;
            else rotateSpeed = -25;

            var dir = _model.target.position - _model.transform.position;
            var angle = Vector3.Angle(dir, _model.transform.forward);
            if (angle < 100)
            {
                var d = Vector3.Distance(_model.transform.position, _player.position);

                _model.transform.RotateAround(_model.target.position, Vector3.up, rotateSpeed * Time.deltaTime);

                if (_model.avoidVectObstacles != Vector3.zero || _model.avoidVectFriends != Vector3.zero) _model.transform.position += _model.transform.forward * 4 * Time.deltaTime;
                if (d<2 && (_model.avoidVectObstacles == Vector3.zero || _model.avoidVectFriends == Vector3.zero)) _model.transform.position += -_model.transform.forward * 4 * Time.deltaTime;
            }
        }

        _dirToTarget = (_player.transform.position - _model.transform.position).normalized;
        _dirToTarget.y = 0;
        _model.transform.forward = _dirToTarget;
    }

    public override void Sleep()
    {

        base.Sleep();
    }

}
