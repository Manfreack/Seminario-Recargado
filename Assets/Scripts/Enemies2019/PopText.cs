using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PopText : MonoBehaviour
{

    public Text myText;
    public float damageText;
    
    public IEnumerator Destroy()
    {
        yield return new WaitForSeconds(2.5f);
        Destroy();
    }

    void Start()
    {
        transform.SetParent(FindObjectOfType<Canvas>().transform, false);
        myText = GetComponent<Text>();        
        myText.text = damageText.ToString();
        StartCoroutine(Destroy());
    }

  
}
