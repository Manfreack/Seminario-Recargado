using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillNode: MonoBehaviour{

    public List<SkillNode> childrens = new List<SkillNode>();
    public List<SkillNode> parents = new List<SkillNode>();
    public Button myButton;
    public bool skillBlocked;

    public void Awake()
    {
        myButton = GetComponent<Button>();
    }

    public void Start()
    {

        if (skillBlocked== true) myButton.interactable = false;  
    }

    public void CheckPlayerPoints(Model player)
    {
        if (player.skillPoints == 0) myButton.interactable = false;

        else
        {
            int amountOfParents = parents.Count;
            foreach (var item in parents)
            {
                if (item.skillBlocked == true) amountOfParents++;
                
            }
            if (amountOfParents < parents.Count) myButton.interactable = false;
        }

    }
}
