using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ViewerEnemy : MonoBehaviour {

    Animator _anim;
    ModelEnemy _model;
    Rigidbody _rb;
    public List<SkinnedMeshRenderer> myMeshes = new List<SkinnedMeshRenderer>();
    public List<Material> myMats = new List<Material>();
    bool damaged;
    float timeShaderDamage;

    public IEnumerator DeadCorrutine()
    {
        yield return new WaitForSeconds(3);
        gameObject.SetActive(false);
    }

	void Awake ()
    {
        _anim  =GetComponent<Animator>();
        _model =GetComponent<ModelEnemy>();
        _rb =GetComponent<Rigidbody>();
        myMeshes.AddRange(GetComponentsInChildren<SkinnedMeshRenderer>());

        _anim.SetBool("Idle", true);

        foreach (var item in myMeshes)
        {
            myMats.Add(item.materials[0]);
            item.materials[0].SetFloat("_Intensity", 0);
        }
    }
	
	// Update is called once per frame
	void Update () {

        DamageShader();
    }

    public void DeadAnim()
    {
        _anim.SetBool("Dead", true);
    }

    public void DeadBody()
    {
        StartCoroutine(DeadCorrutine());
    }

    public void AttackAnim()
    {
        _anim.SetBool("Attack", true);
    }

    public void BackFromAttack()
    {
        _anim.SetBool("Attack", false);
    }

    public void IdleAnim()
    {
        _anim.SetBool("Idle", true);
    }

    public void BackFromIdle()
    {
        _anim.SetBool("Idle", false);
    }

    public void BackFromDamage()
    {
        _anim.SetBool("TakeDamage", false);
    }

    public void TakeDamageAnim()
    {
        _anim.SetBool("TakeDamage", true);
        damaged = true;
        timeShaderDamage = 1;
    }

    public void DamageShader()
    {
        if (damaged && !_model.isDead)
        {
            timeShaderDamage -= Time.deltaTime * 2;

            foreach (var item in myMats) item.SetFloat("_Intensity", timeShaderDamage);

            if (timeShaderDamage <= 0) damaged = false;

        }
    }
}

