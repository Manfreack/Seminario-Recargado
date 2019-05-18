using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CombatNodesManager : MonoBehaviour
{
    public List<CombatNode> myNodes = new List<CombatNode>();

    public bool HideNodes;

    void Update()
    {
        if (!HideNodes)
        {
            myNodes.Clear();

            var childs = GetComponentsInChildren<CombatNode>();

            myNodes.AddRange(childs);

            foreach (var item in myNodes)
            {
                item.GetComponent<MeshRenderer>().enabled = true;
            }
        }

        if (HideNodes)
        {
            foreach (var item in myNodes)
            {
                item.GetComponent<MeshRenderer>().enabled = false;
            }
        }       
    }
}
