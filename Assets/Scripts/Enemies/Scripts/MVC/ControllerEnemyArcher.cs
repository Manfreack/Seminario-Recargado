using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerEnemyArcher : MonoBehaviour {

     ModelEnemyArcher _model;
    ViewerArcher _view;

    void Awake()
    {
        _model = GetComponent<ModelEnemyArcher>();
        _view = GetComponent<ViewerArcher>();

        _model.TakeDamageEvent += _view.TakeDamageAnim;
        _model.IdleEvent += _view.IdleAnim;
        _model.WalkEvent += _view.BackFromIdle;
        _model.DeadEvent += _view.DeadAnim;
        _model.RangeAttackEvent += _view.AttackRangeAnim;
        _model.MeleeAttackEvent += _view.AttackMeleeAnim;
    }

    void Update()
    {
      if (_model.isAttack) _model.AttackRange();
      if (_model.isAttackMelle) _model.Waiting();
     
    }

    private void FixedUpdate()
    {
        if (_model.isPersuit) _model.Persuit();
        if (_model.isOnPatrol) _model.Patrol();
        if (_model.isBackHome && !_model.isAttack && !_model.isPersuit && !_model.isOcuped && !_model.isAttackMelle) _model.BackHome();
    }
}
