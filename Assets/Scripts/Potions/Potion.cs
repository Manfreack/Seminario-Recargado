using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class Potion : MonoBehaviour {

    public enum Type { Health, Extra_Health, Stamina, Costless_Hit, Mana};
    public Type type;

    private void OnTriggerEnter(Collider c)
    {
        if (c.gameObject.GetComponent(typeof(Model)))
        {
            Model model = c.gameObject.GetComponent<Model>();
            int i = Convert.ToInt32(type);
            if (model.potions[i] < 3)
            {
                model.potions[i]++;
                model.view.UpdatePotions(i);
                Destroy(gameObject);
            }
        }
    }
}
