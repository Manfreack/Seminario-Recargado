using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grid : MonoBehaviour
{

    public Cell cellPrefab;
    public Vector2Int size = new Vector2Int(10, 10);
    public float tileSize = 1f;
    public int roomNumber;
    public Cell[,] cells;

    private void Awake()
    {
        cells = new Cell[size.x, size.y];

        for (int i = 0; i < size.x; i++)
        {
            for (int j = 0; j < size.y; j++)
            {
                var cell = Instantiate(cellPrefab);

                cell.transform.parent = transform;
                cell.transform.localPosition = new Vector3(i * tileSize, j * tileSize);
            
                cell.pos = new Vector2Int(i, j);

                cell.room = roomNumber;
                cell.name = "cell" + i + j;
                var obst = Physics.OverlapSphere(cell.transform.position, 0.1f);
                foreach (var item in obst)
                {
                    if (item.gameObject.layer == LayerMask.NameToLayer("Obstacles"))
                    {
                        cell.gameObject.layer = 9;
                        cell.transitable = false;
                        cell.colorPath = Color.red;
                    }
                }

                cells[i, j] = cell;
            }
        }
    }
    
}
