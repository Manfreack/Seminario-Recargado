using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerEnemy : MonoBehaviour {

     ModelEnemy _model;
    ViewerEnemy _view;

	void Awake () {

        _model = GetComponent<ModelEnemy>();
        _view = GetComponent<ViewerEnemy>();

        _model.AttackEvent += _view.AttackAnim;
        _model.IdleEvent += _view.IdleAnim;
        _model.IdleEventBack += _view.BackFromIdle;
        _model.TakeDamageEvent += _view.TakeDamageAnim;
        _model.DeadEvent += _view.DeadAnim;
	}
	
	void Update () {

       
         if (_model.isAttack && !_model.isDead) _model.WaitTurn();
	}

    private void FixedUpdate()
    {
        if (_model.isPersuit && !_model.isDead) _model.Persuit();

       

        if (!_model.isAttack && !_model.isDead && !_model.isPersuit && !_model.isBackHome && !_model.answerCall) _model.Patrol();
    }
}
