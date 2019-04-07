using System;
using UnityEngine;

//[ExecuteInEditMode]
public class GridEntity : MonoBehaviour
{
    public event Action<GridEntity> OnMove = delegate { };
    public Vector3 velocity = new Vector3(0, 0, 0);

    void Update()
    {
        //Optimization: Only on *actual* move
        transform.position += velocity * Time.deltaTime;
        OnMove(this);
    }
}
