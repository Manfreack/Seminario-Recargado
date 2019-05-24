using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PopText : MonoBehaviour
{
    public Text damageText;

    void Start()
    {
        Destroy(gameObject, 2.5f);
    }

    public void SetDamage(float dmg)
    {
        damageText.text = dmg.ToString();
    }
}
