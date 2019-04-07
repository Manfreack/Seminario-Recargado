using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;

//[CustomEditor(typeof(Node))]
//[CanEditMultipleObjects]
public class NodeEditor : Editor {
/*
    void OnSceneGUI()
    {
        Node node = (Node)target;

        Handles.BeginGUI();

        if (GUILayout.Button("Rigth", GUILayout.Width(100), GUILayout.Height(100)))
        {
            var nodes = Physics.OverlapSphere(node.transform.position + node.transform.right * 2, 1f).Where(x => x.GetComponent<Node>());
            if (nodes.Count() == 0)
            {
                Node secondNode ;
                var n = Instantiate(node);
                n.name = "Node";
                n.transform.position = node.transform.position + node.transform.right;

                var times = node.amount - 1;
                secondNode = n;

                for (int i = 0; i < times; i++)
                {
                    var n2 = Instantiate(secondNode);
                    n2.name = "Node";
                    n2.transform.position = secondNode.transform.position + secondNode.transform.right;
                    secondNode = n2;
                }
               
            }
        }

        if (GUILayout.Button("Left", GUILayout.Width(100), GUILayout.Height(100)))
        {
            var nodes = Physics.OverlapSphere(node.transform.position - node.transform.right * 2, 1f).Where(x => x.GetComponent<Node>());
            if (nodes.Count() == 0)
            {
                Node secondNode;
                var n = Instantiate(node);
                n.name = "Node";
                n.transform.position = node.transform.position - node.transform.right;

                var times = node.amount - 1;
                secondNode = n;

                for (int i = 0; i < times; i++)
                {
                    var n2 = Instantiate(secondNode);
                    n2.name = "Node";
                    n2.transform.position = secondNode.transform.position - secondNode.transform.right;
                    secondNode = n2;
                }
            }
        }

        if (GUILayout.Button("Up", GUILayout.Width(100), GUILayout.Height(100)))
        {
            var nodes = Physics.OverlapSphere(node.transform.position + new Vector3(0, 0, 1) * 2, 1f).Where(x => x.GetComponent<Node>());

            if (nodes.Count() == 0)
            {
                Node secondNode;
                var n = Instantiate(node);
                n.name = "Node";
                n.transform.position = node.transform.position + new Vector3(0, 0, 1);

                var times = node.amount - 1;
                secondNode = n;

                for (int i = 0; i < times; i++)
                {
                    var n2 = Instantiate(secondNode);
                    n2.name = "Node";
                    n2.transform.position = secondNode.transform.position + new Vector3(0, 0, 1);
                    secondNode = n2;
                }
            }
        }

        if (GUILayout.Button("Down", GUILayout.Width(100), GUILayout.Height(100)))
        {
            var nodes = Physics.OverlapSphere(node.transform.position - new Vector3(0, 0, 1) * 2, 1f).Where(x => x.GetComponent<Node>());
 
            if (nodes.Count() == 0)
            {
                Node secondNode;
                var n = Instantiate(node);
                n.name = "Node";
                n.transform.position = node.transform.position - new Vector3(0, 0, 1);

                var times = node.amount - 1;
                secondNode = n;

                for (int i = 0; i < times; i++)
                {
                    var n2 = Instantiate(secondNode);
                    n2.name = "Node";
                    n2.transform.position = secondNode.transform.position - new Vector3(0, 0, 1);
                    secondNode = n2;
                }
            }
        }

        Handles.EndGUI();
    }
    */
}
