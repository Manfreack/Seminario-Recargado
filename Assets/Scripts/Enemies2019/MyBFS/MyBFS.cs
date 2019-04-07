using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class MyBFS 
{
    public static List<Node> GetPath(Node start, Node end, List<Node> allnodes)
    {
      
        List<Node> node = new List<Node>();
    
        List<Node> newAmount = new List<Node>();

        List<Node> path = new List<Node>();

        newAmount.Add(start);

        start.visited = true;

        while (newAmount.Count > 0 && !end.visited)
        {
            Node auxiliar = newAmount[0];
            var auxLinks = auxiliar.links;

            foreach (var item in auxLinks)
            {

                if(!item.visited)
                {
                    item.previus = auxiliar;
                    item.visited = true;
                    newAmount.Add(item);
                }

                
            }
            newAmount.Remove(auxiliar);
          
        }

        Node aux = end;

        while(aux.previus !=null)
        {
            path.Add(aux);
            aux = aux.previus;
        }

        path.Add(start);

        foreach (var item in allnodes)
        {
            item.previus = null;
            item.visited = false;
        }

        return path;
    }
}
