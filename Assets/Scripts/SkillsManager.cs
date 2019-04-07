using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillsManager: MonoBehaviour  {

    public Model player;
    public Text skillPointsText;
    public GameObject panel;
    public List<SkillNode> skillNodes = new List<SkillNode>();
    bool panelActive;
    public int counterExtraFireDamage;


    public void Update()
    {
        if (Input.GetKeyUp(KeyCode.N) && panelActive == false)
        {
            panel.SetActive(true);
            panelActive = true;
            skillPointsText.text = "SkillPoints: " + player.skillPoints;
            CheckNodes();
      
        }
        else if (Input.GetKeyUp(KeyCode.N) && panelActive == true)
        {
            panel.SetActive(false);
            panelActive = false;
        }
    }

    public void ExtraDamage(SkillNode node)
    {
        if (counterExtraFireDamage < 3)
        {         
            player.extraFireDamage += 10;
            counterExtraFireDamage++;
            var textButton = node.myButton.GetComponentInChildren<Text>();
            textButton.text = "ExtraDamage " + counterExtraFireDamage + "/3";
            player.skillPoints--;
            skillPointsText.text = "SkillPoints: " + player.skillPoints;
        }

        if (counterExtraFireDamage == 3)
        {
            node.skillBlocked = true;
            foreach (var item in node.childrens)
            {
                item.myButton.interactable = true;
            }
            node.myButton.interactable = false;
        }
        CheckNodes();
    }

    public void BiggerFireBall(SkillNode node)
    {
        player.mySkills.FireSkill1 = true;
        player.skillPoints--;
        node.myButton.interactable = false;
        skillPointsText.text = "SkillPoints: " + player.skillPoints;
        node.skillBlocked = true;
        foreach (var item in node.childrens) item.myButton.interactable = true;
        CheckNodes();
    }


    public void CheckNodes()
    {
        foreach (var item in skillNodes) item.CheckPlayerPoints(player);

    }
}
