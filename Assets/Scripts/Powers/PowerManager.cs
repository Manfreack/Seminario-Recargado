using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class PowerManager : MonoBehaviour {
  
    public Ipower currentPowerAction;
    public IDecorator _currentDecorator;
    public List<GameObject> powerParticles = new List<GameObject>();
    public List<BoxCollider> powerColliders = new List<BoxCollider>();
    public List<Collider> enemies= new List<Collider>();
    Model _model;
    Powers _power;
    public bool constancepower;
    public int amountOfTimes;
	Vector3 mousePosition;
    public Dictionary<int, Action<Powers,Model>> powerDictionary = new Dictionary<int, Action<Powers, Model>>();

    void Awake () {

        _model = FindObjectOfType<Model>();
        _power = FindObjectOfType<Powers>();

        powerDictionary.Add(0, StocadaWarrior);
        powerDictionary.Add(1, WarriorRotatePower);
        powerDictionary.Add(2, UppercutWarrior);
        powerDictionary.Add(3, JumpAttackWarrior);
    }
	
	void Update () {
		
        if (constancepower==true) currentPowerAction.Ipower();
    }

    public void SetIPower(int id, Powers power, Model model)
    {
        _model = model;
        _power = power;

        powerDictionary[id](_power,_model);
    }

    public void WarriorRotatePower(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        currentPowerAction.Ipower();
        constancepower = false;
    }

    public void JumpAttackWarrior(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        constancepower = true;
    }

    public void StocadaWarrior(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        constancepower = true;
    }

    public void UppercutWarrior(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        currentPowerAction.Ipower();
        constancepower = false;
    }

    public void ShieldPunchTanke(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        currentPowerAction = new ShieldPunchTanke(model);
        currentPowerAction.Ipower();
        constancepower = false;

    }

    public void Slame(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        var rb = model.GetComponent<Rigidbody>();
        var actualPos = model.transform.position;
        var radius = model.mySkills.RadiusSlameSkill;
        float extraDamage = model.extraSlameDamage;
        currentPowerAction = new Slame(actualPos, extraDamage, radius, rb);
        currentPowerAction.Ipower();
        constancepower = false;
    }

    public void ChargeTanke(Powers power, Model model) {

        model.ReturnBulletToPool(power);
        constancepower = true;
    }

    public void FireBall(Powers power, Model model) {

       /* float extraDamage = model.extraFireDamage;
        currentPowerAction = new FireBall(power, model, extraDamage);
        power.SetStrategy(currentPowerAction);
        var p = Instantiate(powerParticles[id]);
        power.newParticles = p;
        p.transform.position = power.transform.position;
        p.transform.SetParent(power.transform);
        p.transform.forward = power.transform.forward;
        SetDecorator(id, p, power, model);
        */
    }

    public void SetDecorator(int id , GameObject particles, Powers power , Model model)
    {

        if (id == 0)
        {
            if (model.mySkills.FireSkill1)
            {
                _currentDecorator = new BiggerFireBall(particles);
                power.SetDecorator(_currentDecorator);
            }
        }
    }

   
}
