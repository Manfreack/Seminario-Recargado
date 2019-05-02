﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PopText : MonoBehaviour
{

    public Text myText;
    public float damageText;
    
    public IEnumerator DestroyText()
    {
        yield return new WaitForSeconds(2.5f);
        Destroy(gameObject);
    }

    void Start()
    {
        transform.SetParent(FindObjectOfType<Canvas>().transform, false);
        myText = GetComponent<Text>();
        int damage = (int)damageText;
        myText.text = damage.ToString();
        StartCoroutine(DestroyText());
    }

  
}
