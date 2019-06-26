using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour
{
    public Transform _CheckTransform;

    public enum TextImputs { DOOR_OPEN, GET_KEY, DOOR_CLOSE }
    public EnemyEntity enemyDropKey;
    public bool dropKey;
    public bool playerHasKey;
    public LevelKey keyPrefab;
    public RawImage fade;
    public Text textFade;
    bool startFadeText;

    public Dictionary<TextImputs, string> textsDictionary = new Dictionary<TextImputs, string>();

   

    public IEnumerator DesapearText()
    {
        yield return new WaitForSeconds(4f);
        startFadeText = true;
        textFade.enabled = false;
    }

    public void Awake()
    {
        textsDictionary.Add(TextImputs.DOOR_CLOSE, "It's closed.");
        textsDictionary.Add(TextImputs.GET_KEY, "Key collected.");
        fade.enabled = false;
        textFade.enabled = false;
    }

   void Update()
    {
        if(enemyDropKey.isDead && !dropKey)
        {
            var key = Instantiate(keyPrefab);
            key.transform.position = enemyDropKey.transform.position + new Vector3(0,0.5f,0);
            dropKey = true;
        }

        if(startFadeText)
        {
            fade.CrossFadeAlpha(0, 1, false);          
        }

    }

    public void SetText(TextImputs t)
    {
        fade.CrossFadeAlpha(1, 0.01f, false);
        textFade.text = textsDictionary[t];
        fade.enabled = true;
        textFade.enabled = true;
        startFadeText = false;
        StartCoroutine(DesapearText());
    }

}
