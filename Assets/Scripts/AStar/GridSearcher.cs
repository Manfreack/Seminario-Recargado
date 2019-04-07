using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridSearcher : MonoBehaviour
{
    public enum SearchType { BFS, DFS, Dijkstra, AStar, ThetaStar }
    public SearchType searchType; //El tipo de busqueda que vamos a realizar

    public enum MovementType { Straight, StraightDiagonal }
    public MovementType movementType;

    public Grid grid;//Referencia a la grilla

    public float heuristicMultiplier = 1f;

    public List<Vector2Int> Directions
    {
        get
        {
            switch (movementType)
            {
                case MovementType.StraightDiagonal:
                    return diagonalDirs;
                case MovementType.Straight:
                default:
                    return straightDirs;
            }
        }
    }

    public LayerMask blockedMask;

    public Cell start;//Nodo inicial
    public Cell end;//Nodo final

    private List<Vector2Int> straightDirs = new List<Vector2Int>();
    private List<Vector2Int> diagonalDirs = new List<Vector2Int>();
    private List<Cell> path = new List<Cell>();

    #region Debug
    public Color startColor = Color.cyan;
    public Color endColor = Color.magenta;
    public Color startCheckedColor = Color.green;
    public Color endChekedColor = Color.red;
    private List<Cell> cellsChecked;
    public float waitTime;
    public LineRenderer lineRenderer;
    #endregion

    //En start porque la grid se genera en un Awake.
    void Start()
    {
        //Straight Directions
        straightDirs.Add(Vector2Int.right);
        straightDirs.Add(Vector2Int.down);
        straightDirs.Add(Vector2Int.left);
        straightDirs.Add(Vector2Int.up);

        // Diagonal Directions
        diagonalDirs.Add(Vector2Int.right);
        diagonalDirs.Add(Vector2Int.right + Vector2Int.down);
        diagonalDirs.Add(Vector2Int.down);
        diagonalDirs.Add(Vector2Int.down + Vector2Int.left);
        diagonalDirs.Add(Vector2Int.left);
        diagonalDirs.Add(Vector2Int.left + Vector2Int.up);
        diagonalDirs.Add(Vector2Int.up);
        diagonalDirs.Add(Vector2Int.up + Vector2Int.right);

        foreach (var cell in grid.cells)//A cada una de las celdas
        {
            cell.OnSelect += OnCellSelected;//Le decimos que hacer cuando las seleccionan
        }
    }

    private void OnCellSelected(Cell cell)
    {
        if (!cell.Transitable) return;//Si la celda esta bloqueada no hacemos nada

        ClearAll();//Debug - limpia el color de todas las celdas

        start = end;//Nuestra celda inicial va a ser la que antes era la final
        end = cell;//Y la celda final va a ser la que estemos seleccionando ahora

        //Debug - Le seteamos los colores correspondientes al inicio y al fin
       // if (start) start.SetColor(startColor);
       // if (end) end.SetColor(endColor);

        if (end && start)//Si ninguna de los dos es null
            Search(start, end);//Ejecutamos la busqueda
    }


    public List<Cell> Search(Cell myCell, Cell targetCell)
    {

        start = myCell;
        end = targetCell;
        if (start == null || end == null) return new List<Cell>();
       
        ClearAll();
        cellsChecked = new List<Cell>();//Debug - limpiamos la lista donde nuestro algoritmo va a agregar
                                        //cada celda que vaya chequeando. Nos sirve para saber el orden de
                                        //ejecucion.        
        foreach (var item in path)
        {
            item.colorPath = Color.grey;
        }
        //Aca obtenemos el path
        /*switch (searchType)
        {
            case SearchType.BFS:
                path = BFS.Run(start, Satisfies, GetNeighbours);
                break;
            case SearchType.DFS:
                path = DFS.Run(start, Satisfies, GetNeighbours);
                break;
            case SearchType.Dijkstra:
                path = Dijkstra.Run(start, Satisfies, GetWightedNeighbours);
                break;
            case SearchType.AStar:
                path = AStar.Run(start, Satisfies, GetWightedNeighbours, Heuristic);
                break;
            case SearchType.ThetaStar:
                path = ThetaStar.Run(start, Satisfies, GetWightedNeighbours, Heuristic, InSight, EuclideanDist);
                break;
        }
        */
        path = AStar.Run(start, Satisfies, GetWightedNeighbours, Heuristic);
        //Aca ya tenemos el path propiamente dicho.
        //Podriamos pasarselo a algun agente para que use la lista de nodos como waypoints para
        //recorrerla, o lo que fuera.

        //Debug - En nuestro caso vamos a pintar las celdas del path.
        //StartCoroutine(PaintRoutine());
        PaintRoutine();
        
        return path;
    }

    private bool Satisfies(Cell cell)
    {
        cellsChecked.Add(cell);//Debug
        return cell.Equals(end);//Es nuestra celda el final del camino?
    }

    private List<Cell> GetNeighbours(Cell current)
    {
        var neighbours = new List<Cell>();

        for (int i = 0; i < Directions.Count; i++)
        {
            var newPos = current.pos + Directions[i];
            if (!InBounds(newPos)) continue;

            var neighbour = grid.cells[newPos.x, newPos.y];
            var aux1 = grid.cells[newPos.x, current.pos.y];
            var aux2 = grid.cells[current.pos.x, newPos.y];
            if (neighbour.Transitable && aux1.Transitable && aux2.Transitable)
                neighbours.Add(neighbour);
        }

        return neighbours;
    }

    private List<Tuple<Cell, float>> GetWightedNeighbours(Cell current)
    {
        var neighbours = new List<Tuple<Cell, float>>();

        for (int i = 0; i < Directions.Count; i++)
        {
            var newPos = current.pos + Directions[i];
            if (!InBounds(newPos)) continue;

            var neighbour = grid.cells[newPos.x, newPos.y];
            var aux1 = grid.cells[newPos.x, current.pos.y];
            var aux2 = grid.cells[current.pos.x, newPos.y];
            if (neighbour.Transitable && aux1.Transitable && aux2.Transitable)
                neighbours.Add(Tuple.Create(neighbour, Directions[i].magnitude * neighbour.Cost));
        }

        return neighbours;
    }

    private float Heuristic(Cell cell)
    {
        //return EuclideanDist(end, cell);
        return EuclideanDist(end, cell) * heuristicMultiplier;
    }

    private float EuclideanDist(Cell a, Cell b)
    {
        return Vector2Int.Distance(a.pos, b.pos);
    }

    private bool InSight(Cell a, Cell b)
    {
        var start = a.transform.position;
        var dir = (b.transform.position - a.transform.position).normalized;
        var dist = Vector2.Distance(b.transform.position, a.transform.position);
        var hit = Physics2D.CircleCast(a.transform.position, 0.45f, dir, dist, blockedMask);
        return hit.collider == null;
    }

    private bool InBounds(Vector2Int pos)
    {
        return pos.x >= 0 && pos.x < grid.size.x &&
               pos.y >= 0 && pos.y < grid.size.y;
    }

    //Debug
    private void ClearAll()
    {
       /* StopAllCoroutines();//Detenemos la corrutina de pintado
        lineRenderer.positionCount = 0;
       /* foreach (var cell in grid.cells)
        {
            if (cell.Transitable)
                cell.SetColor(cell.defaultColor);//Las pintamos con el color por defecto
        }
        */
    }

    private void ResetCosts()
    {
        foreach (var cell in grid.cells)
        {
            cell.Cost = 1;
        }
    }

    private void PaintRoutine()
    {

        //Pintamos las celdas checkeadas
        /*for (int i = 0; i < cellsChecked.Count; i++)
        {
            var current = cellsChecked[i];
            current.SetColor(Color.Lerp(startCheckedColor, endChekedColor, i / (float)(cellsChecked.Count - 1)));
            //yield return new WaitForSeconds(waitTime);
        }
        */
        if (path != null)
        {
            var positions = new List<Vector3>();
            //Pintamos el path
            for (int i = 0; i < path.Count; i++)
            {
                var current = path[i];
                current.colorPath = Color.blue;
               // current.SetColor(Color.Lerp(startColor, endColor, i / (float)(path.Count - 1)));
                //positions.Add(current.transform.position - Vector3.forward * 0.1f);
                //yield return new WaitForSeconds(waitTime);
            }
            //lineRenderer.positionCount = positions.Count;
            //lineRenderer.SetPositions(positions.ToArray());
        }
    }

    /*private IEnumerator PaintRoutine()
    {

        //Pintamos las celdas checkeadas
        for (int i = 0; i < cellsChecked.Count; i++)
        {
            var current = cellsChecked[i];
            current.SetColor(Color.Lerp(startCheckedColor, endChekedColor, i / (float)(cellsChecked.Count - 1)));
            yield return new WaitForSeconds(waitTime);
        }

        if (path != null)
        {
            var positions = new List<Vector3>();
            //Pintamos el path
            for (int i = 0; i < path.Count; i++)
            {
                var current = path[i];
                current.colorPath = Color.blue;
                current.SetColor(Color.Lerp(startColor, endColor, i / (float)(path.Count - 1)));
                positions.Add(current.transform.position - Vector3.forward * 0.1f);
                yield return new WaitForSeconds(waitTime);
            }
            lineRenderer.positionCount = positions.Count;
            lineRenderer.SetPositions(positions.ToArray());
        }
    }
    */

    //Funcion para mesclar una lista
    public List<T> Shuffle<T>(List<T> list)
    {
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = UnityEngine.Random.Range(0, n + 1);
            T value = list[k];
            list[k] = list[n];
            list[n] = value;
        }
        return list;
    }

    private bool showNumbers = false;

    private void Update()
    {
       
    }

    private void OnDrawGizmos()
    {
        for (int i = 1; i < path.Count; i++)
        {
            Gizmos.color = Color.magenta;
            Gizmos.DrawLine(path[i].transform.position, path[i - 1].transform.position);
        }
    }
}
