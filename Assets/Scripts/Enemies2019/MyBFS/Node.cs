using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class Node : MonoBehaviour
{
    public List<Node> links = new List<Node>();
    public Node previus;
    public bool visited;
    public bool patrolNode;
    public bool isBusy;

    public IEnumerator UpdateBusyNode()
    {
        while (true)
        {
            var obs = Physics.OverlapSphere(transform.position, 1.5f).Where(x =>
            {

                if (x.gameObject.layer == LayerMask.NameToLayer("Enemy")) return true;
                else return false;

            });

            if (obs.Count() > 0) isBusy = true;
            else isBusy = false;
            yield return new WaitForSeconds(0.333f);
        }
    }

    public void Awake()
    {
        StartCoroutine(UpdateBusyNode());

    }

    public void OnDrawGizmos()
    {
        foreach (var item in links)
        {
            Gizmos.DrawLine(transform.position, item.transform.position);
        }
    }
}
