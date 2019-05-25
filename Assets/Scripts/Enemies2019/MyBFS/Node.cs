using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Node : MonoBehaviour
{
    public List<Node> links = new List<Node>();
    public Node previus;
    public bool visited;
    public bool patrolNode;


    public void OnDrawGizmos()
    {
        foreach (var item in links)
        {
            Gizmos.DrawLine(transform.position, item.transform.position);
        }
    }
}
