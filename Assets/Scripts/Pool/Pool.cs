using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Pool<T>
{
    private List<PoolObject<T>> _poolList;
    public delegate T CallbackFactory();

    private int _count;
    private bool _isDinamic = false;
    private PoolObject<T>.PoolCallback _init;
    private PoolObject<T>.PoolCallback _finalize;
    private CallbackFactory _factoryMethod;
    /// <summary>
    /// Constructor, se encargar de guardar las referencias que vamos a necesitar para crear el objecto que queremos poolear,
    /// vamos a pedir un stock inicial,Como vamos a crear cada objeto y sus funciones de como inicializarlos y finalizarlos,ademas de preguntar si lo queremos dinamico al pool
    /// </summary>
    /// <param name="initialStock"></param>
    /// <param name="factoryMethod"></param>
    /// <param name="initialize"></param>
    /// <param name="finalize"></param>
    /// <param name="isDinamic"></param>
    public Pool(int initialStock, CallbackFactory factoryMethod, PoolObject<T>.PoolCallback initialize, PoolObject<T>.PoolCallback finalize, bool isDinamic)
    {
        //Creamos una lista de objetos Pooleables
        _poolList = new List<PoolObject<T>>();

        //Guardamos las referencias para cuando los necesitemos.
        _factoryMethod = factoryMethod;
        _isDinamic = isDinamic;
        _count = initialStock;
        _init = initialize;
        _finalize = finalize;

        //Generamos el stock inicial.
        for (int i = 0; i < _count; i++)
        {
            _poolList.Add(new PoolObject<T>(_factoryMethod(), _init, _finalize));

        }
    }
    /// <summary>
    /// Se va a encargar de verificar cual es el primer objecto que no este en uso,para devolverlo y poder usarlo
    /// </summary>
    /// <returns></returns>
    public T GetObjectFromPool()
    {
        for (int i = 0; i < _poolList.Count-1; i++)
        {
            if (!_poolList[i].isActive)
            {
               
                _poolList[i].isActive = true;
                return _poolList[i].GetObj;
            }
        }
        //Si tenemos todos los objecto en uso,vamos a preguntar si es dinamico para poder crear mas
        if (_isDinamic)
        {
            PoolObject<T> po = new PoolObject<T>(_factoryMethod(), _init, _finalize);
            po.isActive = true;
            _poolList.Add(po);
            _count++;
            return po.GetObj;
        }
        return default(T);
    }

    /// <summary>
    /// Funcion para desactivar un objeto,vamos a recorrer en nuestro lista de ObjectoPooleables para comparar con el que llego por parametro
    /// Si es igual lo desactivamos
    /// </summary>
    /// <param name="obj"></param>
    public void DisablePoolObject(T obj)
    {
        foreach (PoolObject<T> poolObj in _poolList)
        {
            if (poolObj.GetObj.Equals(obj))
            {
                poolObj.isActive = false;
                return;
            }
        }
    }
}
