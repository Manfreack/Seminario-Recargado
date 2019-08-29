using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Menu_Controlls : MonoBehaviour
{
    public int pageNumShowing;
    public bool changingPage;

    [Header("Canvas References")]
    public Button leftButton;
    public Button rightButton;

    [Header("Material Stuff")]
    public float dissolveSpeed;
    public Material normalControlls_mat;
    [Range(0, 1)]
    public float normalControlls_dissolveAmount;
    public Material specialControlls_mat;
    [Range(0, 1)]
    public float specialControlls_dissolveAmount;

    // Start is called before the first frame update
    void Start()
    {
        pageNumShowing = 0;
        normalControlls_dissolveAmount = 0;
        normalControlls_mat.SetFloat("_DissolveAmount", normalControlls_dissolveAmount);
        specialControlls_dissolveAmount = 0;
        specialControlls_mat.SetFloat("_DissolveAmount", specialControlls_dissolveAmount);
        StartCoroutine(Initialize());
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //if (normalControlls_dissolveAmount == 0 || normalControlls_dissolveAmount == 1 || specialControlls_dissolveAmount == 0 || specialControlls_dissolveAmount == 1)
        //{
        //    changingPage = false;
        //}
        if (normalControlls_dissolveAmount > 0 && normalControlls_dissolveAmount < 1 || specialControlls_dissolveAmount > 0 && specialControlls_dissolveAmount < 1)
        {
            changingPage = true;
        }
        else changingPage = false;

        if (pageNumShowing == 1 || pageNumShowing == 0)
        {
            leftButton.interactable = false;
        }
        else leftButton.interactable = true;

        if (pageNumShowing == 2)
        {
            rightButton.interactable = false;
        }
        else rightButton.interactable = true;
    }

    public void ButtonLeftPressed()
    {
        if (!changingPage)
        {
            StartCoroutine(ChangePageLeft());
        }
        //if (pageNumShowing == 1)
        //{
        //    if (normalControlls_dissolveAmount > 0) normalControlls_dissolveAmount -= dissolveSpeed * Time.deltaTime;
        //    if (normalControlls_dissolveAmount < 0) normalControlls_dissolveAmount = 0;

        //    normalControlls_mat.SetFloat("_DissolveAmount", normalControlls_dissolveAmount);
        //    pageNumShowing -= 1;
        //}

        //if (pageNumShowing == 2)
        //{
        //    if (specialControlls_dissolveAmount > 0) specialControlls_dissolveAmount -= dissolveSpeed * Time.deltaTime;
        //    if (specialControlls_dissolveAmount < 0) specialControlls_dissolveAmount = 0;

        //    specialControlls_mat.SetFloat("_DissolveAmount", specialControlls_dissolveAmount);
        //    pageNumShowing -= 1;
        //}
    }

    public void ButtonRightPressed()
    {
        if (!changingPage)
        {
            StartCoroutine(ChangePageRight());
        }
        //if (pageNumShowing == 0)
        //{
        //    if (normalControlls_dissolveAmount < 1) normalControlls_dissolveAmount += dissolveSpeed * Time.deltaTime;
        //    if (normalControlls_dissolveAmount > 1) normalControlls_dissolveAmount = 1;

        //    normalControlls_mat.SetFloat("_DissolveAmount", normalControlls_dissolveAmount);
        //    pageNumShowing += 1;
        //}

        //if (pageNumShowing == 1)
        //{
        //    if (specialControlls_dissolveAmount < 1) specialControlls_dissolveAmount += dissolveSpeed * Time.deltaTime;
        //    if (specialControlls_dissolveAmount > 1) specialControlls_dissolveAmount = 1;

        //    specialControlls_mat.SetFloat("_DissolveAmount", specialControlls_dissolveAmount);
        //    pageNumShowing += 1;
        //}
    }

    public IEnumerator Initialize()
    {
        if (pageNumShowing == 0)
        {
            while (pageNumShowing == 0)
            {
                if (normalControlls_dissolveAmount < 1) normalControlls_dissolveAmount += dissolveSpeed * Time.deltaTime;
                if (normalControlls_dissolveAmount > 1) normalControlls_dissolveAmount = 1;

                normalControlls_mat.SetFloat("_DissolveAmount", normalControlls_dissolveAmount);
                //pageNumShowing += 1;
                if (normalControlls_dissolveAmount == 1)
                {
                    //StopAllCoroutines();
                    pageNumShowing = 1;
                }
                yield return new WaitForEndOfFrame();
            }
        }
    }

    public IEnumerator ChangePageLeft()
    {
        //if (pageNumShowing == 1)
        //{
        //    while (pageNumShowing == 1)
        //    {
        //        if (normalControlls_dissolveAmount > 0) normalControlls_dissolveAmount -= dissolveSpeed * Time.deltaTime;
        //        if (normalControlls_dissolveAmount < 0) normalControlls_dissolveAmount = 0;

        //        normalControlls_mat.SetFloat("_DissolveAmount", normalControlls_dissolveAmount);
        //        if (normalControlls_dissolveAmount == 0)
        //        {
        //            //StopAllCoroutines();
        //            pageNumShowing = 0;
        //        }
        //        yield return new WaitForEndOfFrame();
        //    }
        //}

        if (pageNumShowing == 2)
        {
            while (pageNumShowing == 2)
            {
                if (specialControlls_dissolveAmount > 0) specialControlls_dissolveAmount -= dissolveSpeed * Time.deltaTime;
                if (specialControlls_dissolveAmount < 0) specialControlls_dissolveAmount = 0;

                specialControlls_mat.SetFloat("_DissolveAmount", specialControlls_dissolveAmount);
                //pageNumShowing -= 1;
                if (specialControlls_dissolveAmount == 0)
                {
                    //StopAllCoroutines();
                    pageNumShowing = 1;
                }
                yield return new WaitForEndOfFrame();
            }
        }
    }

    public IEnumerator ChangePageRight()
    {
        if (pageNumShowing == 1)
        {
            while (pageNumShowing == 1)
            {
                if (specialControlls_dissolveAmount < 1) specialControlls_dissolveAmount += dissolveSpeed * Time.deltaTime;
                if (specialControlls_dissolveAmount > 1) specialControlls_dissolveAmount = 1;

                specialControlls_mat.SetFloat("_DissolveAmount", specialControlls_dissolveAmount);
                //pageNumShowing += 1;
                if (specialControlls_dissolveAmount == 1)
                {
                    //StopAllCoroutines();
                    pageNumShowing = 2;
                }
                yield return new WaitForEndOfFrame();
            }
        }

        //if (pageNumShowing == 0)
        //{
        //    while (pageNumShowing == 0)
        //    {
        //        if (normalControlls_dissolveAmount < 1) normalControlls_dissolveAmount += dissolveSpeed * Time.deltaTime;
        //        if (normalControlls_dissolveAmount > 1) normalControlls_dissolveAmount = 1;

        //        normalControlls_mat.SetFloat("_DissolveAmount", normalControlls_dissolveAmount);
        //        //pageNumShowing += 1;
        //        if (normalControlls_dissolveAmount == 1)
        //        {
        //            //StopAllCoroutines();
        //            pageNumShowing = 1;
        //        }
        //        yield return new WaitForEndOfFrame();
        //    }
        //}
    }
}
